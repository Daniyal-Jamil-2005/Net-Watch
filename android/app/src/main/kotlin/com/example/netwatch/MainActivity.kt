package com.example.netwatch

import android.app.usage.UsageStatsManager
import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.TrafficStats
import android.net.wifi.WifiManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.Inet4Address
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.NetworkInterface
import java.net.Socket
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.netwatch/native"
    private val TAG = "NetWatch"
    private var multicastLock: WifiManager.MulticastLock? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getArpTable" -> {
                    Thread { runOnUiThread { result.success(readArpTable()) } }.start()
                }

                "discoverDevices" -> {
                    Thread {
                        try {
                            val devices = discoverSubnetDevices()
                            runOnUiThread { result.success(devices) }
                        } catch (e: Exception) {
                            runOnUiThread { result.success(emptyList<Map<String, Any>>()) }
                        }
                    }.start()
                }

                "ssdpDiscover" -> {
                    Thread {
                        try {
                            val r = ssdpDiscover()
                            runOnUiThread { result.success(r) }
                        } catch (e: Exception) {
                            runOnUiThread { result.success(emptyList<Map<String, Any>>()) }
                        }
                    }.start()
                }

                "getTrafficStats" -> {
                    val uid = call.argument<Int>("uid")
                    if (uid != null) result.success(mapOf("rx" to TrafficStats.getUidRxBytes(uid), "tx" to TrafficStats.getUidTxBytes(uid)))
                    else result.success(mapOf("rx" to TrafficStats.getTotalRxBytes(), "tx" to TrafficStats.getTotalTxBytes()))
                }

                "getUsageStats" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
                        val end = System.currentTimeMillis()
                        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, end - 86400000, end)
                        result.success(stats?.map { mapOf("packageName" to it.packageName, "totalTimeInForeground" to it.totalTimeInForeground) } ?: emptyList<Any>())
                    } else result.error("UNSUPPORTED", "Requires Android 5.0+", null)
                }

                "getNetworkInterfaces" -> {
                    try {
                        val list = mutableListOf<Map<String, Any>>()
                        for (intf in NetworkInterface.getNetworkInterfaces()) {
                            val addrs = intf.interfaceAddresses.map { mapOf("address" to (it.address.hostAddress ?: ""), "prefixLength" to it.networkPrefixLength.toString()) }
                            list.add(mapOf("name" to intf.name, "addresses" to addrs))
                        }
                        result.success(list)
                    } catch (e: Exception) { result.error("ERROR", e.message, null) }
                }

                "acquireMulticastLock" -> {
                    if (multicastLock == null) {
                        val wm = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                        multicastLock = wm.createMulticastLock("netwatch_lock")
                        multicastLock?.setReferenceCounted(true)
                    }
                    multicastLock?.acquire()
                    result.success(true)
                }
                "releaseMulticastLock" -> {
                    if (multicastLock?.isHeld == true) multicastLock?.release()
                    result.success(true)
                }
                "getWifiInfo" -> result.success(getWifiInfoData())
                "getDeviceInfo" -> {
                    val wm = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    @Suppress("DEPRECATION") val ipInt = wm.connectionInfo.ipAddress
                    val ipStr = if (ipInt != 0) intToIp(ipInt) else getLocalIpFallback()
                    result.success(mapOf("model" to Build.MODEL, "ip" to ipStr))
                }
                else -> result.notImplemented()
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  ENRICHED DEVICE DISCOVERY
    // ═══════════════════════════════════════════════════════════════

    private fun discoverSubnetDevices(): List<Map<String, Any>> {
        val wm = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        @Suppress("DEPRECATION") val ipInt = wm.connectionInfo.ipAddress
        if (ipInt == 0) return emptyList()

        val myIp = intToIp(ipInt)
        val subnet = myIp.substringBeforeLast(".")
        Log.d(TAG, "Scanning $subnet.x (self: $myIp)")

        val foundDevices = CopyOnWriteArrayList<Map<String, Any>>()
        val executor = Executors.newFixedThreadPool(64)
        val latch = CountDownLatch(254)

        for (i in 1..254) {
            executor.submit {
                try {
                    val targetIp = "$subnet.$i"
                    val addr = InetAddress.getByName(targetIp)
                    val reachable = addr.isReachable(1000)

                    if (reachable) {
                        val isGateway = (i == 1)
                        val isSelf = (targetIp == myIp)

                        // ── Reverse DNS ──
                        val rdns = try {
                            val h = addr.canonicalHostName ?: ""
                            if (h == targetIp) "" else h
                        } catch (_: Exception) { "" }

                        // ── NetBIOS & LLMNR name query (Windows PCs, NAS devices) ──
                        var netbiosName = ""
                        if (!isGateway) {
                            netbiosName = getNetBIOSName(targetIp)
                            if (netbiosName.isEmpty() && getTtl(targetIp) in 65..128) {
                                // If it's likely a Windows machine and NetBIOS failed, try LLMNR
                                netbiosName = getLlmnrName(targetIp)
                            }
                        }

                        // ── TTL + OS ──
                        val ttl = getTtl(targetIp)
                        val osGuess = when {
                            isGateway -> "Router"
                            isSelf -> "Android"
                            ttl in 1..64 -> "Linux/Android"
                            ttl in 65..128 -> "Windows"
                            ttl in 129..255 -> "Network Equipment"
                            else -> "Unknown"
                        }

                        // ── Port-based device type ──
                        val deviceType = when {
                            isGateway -> "router"
                            isSelf -> "self"
                            else -> guessDeviceType(targetIp)
                        }

                        // ── Best hostname ──
                        val bestName = when {
                            isSelf -> Build.MODEL
                            netbiosName.isNotEmpty() -> netbiosName
                            rdns.isNotEmpty() -> rdns.split(".").first()
                            else -> ""
                        }

                        foundDevices.add(mapOf(
                            "ip" to targetIp,
                            "hostname" to bestName,
                            "ttl" to ttl,
                            "osGuess" to osGuess,
                            "deviceType" to deviceType,
                            "isGateway" to isGateway,
                            "isSelf" to isSelf,
                            "isReachable" to true
                        ))
                        Log.d(TAG, "[$targetIp] name=$bestName os=$osGuess type=$deviceType ttl=$ttl")
                    }
                } catch (_: Exception) {
                } finally { latch.countDown() }
            }
        }

        latch.await(15, TimeUnit.SECONDS)
        executor.shutdownNow()

        // Always include gateway
        if (foundDevices.none { it["ip"] == "$subnet.1" }) {
            foundDevices.add(mapOf(
                "ip" to "$subnet.1", "hostname" to "Gateway", "ttl" to 0,
                "osGuess" to "Router", "deviceType" to "router",
                "isGateway" to true, "isSelf" to false, "isReachable" to true
            ))
        }

        Log.d(TAG, "Discovery done: ${foundDevices.size} devices")
        return foundDevices.toList()
    }

    // ═══════════════════════════════════════════════════════════════
    //  NetBIOS Name Service query (port 137)
    //  Gets real PC names like "DANIYAL-PC", "JEDI-WORKSTATION"
    // ═══════════════════════════════════════════════════════════════

    private fun getNetBIOSName(ip: String): String {
        return try {
            val socket = DatagramSocket()
            socket.soTimeout = 500

            // NBNS Node Status Request (wildcard query)
            val query = byteArrayOf(
                0x80.toByte(), 0x01.toByte(),  // Transaction ID
                0x00, 0x00,                     // Flags: query
                0x00, 0x01,                     // Questions: 1
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // Answers/Auth/Additional: 0
                0x20,                           // Name length: 32
                // Encoded "*" (wildcard) in NetBIOS Level 2 encoding
                0x43, 0x4b, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41,
                0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41,
                0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41,
                0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41,
                0x00,                           // Name terminator
                0x00, 0x21,                     // Type: NBSTAT
                0x00, 0x01                      // Class: IN
            )

            val addr = InetAddress.getByName(ip)
            socket.send(DatagramPacket(query, query.size, addr, 137))

            val buf = ByteArray(1024)
            val recv = DatagramPacket(buf, buf.size)
            socket.receive(recv)
            socket.close()

            val data = recv.data
            if (recv.length > 57) {
                val nameCount = data[56].toInt() and 0xFF
                if (nameCount > 0 && recv.length > 75) {
                    // Each name entry: 15 bytes name + 1 byte suffix + 2 bytes flags
                    // First entry with suffix 0x00 is the workstation name
                    for (n in 0 until nameCount) {
                        val offset = 57 + (n * 18)
                        if (offset + 18 > recv.length) break
                        val suffix = data[offset + 15].toInt() and 0xFF
                        if (suffix == 0x00) {
                            // This is the computer name
                            val nameBytes = data.copyOfRange(offset, offset + 15)
                            val name = String(nameBytes, Charsets.US_ASCII).trim()
                            if (name.isNotBlank() && !name.startsWith("\u0000")) {
                                Log.d(TAG, "NetBIOS [$ip]: $name")
                                return name
                            }
                        }
                    }
                }
            }
            ""
        } catch (_: Exception) { "" }
    }

    // ═══════════════════════════════════════════════════════════════
    //  LLMNR Name Service query (port 5355)
    //  Fallback for modern Windows machines without NetBIOS
    // ═══════════════════════════════════════════════════════════════

    private fun getLlmnrName(ip: String): String {
        return try {
            val socket = DatagramSocket()
            socket.soTimeout = 500

            val parts = ip.split(".")
            if (parts.size != 4) return ""
            val arpa = "${parts[3]}.${parts[2]}.${parts[1]}.${parts[0]}.in-addr.arpa"

            // Construct DNS PTR query for LLMNR
            val query = mutableListOf<Byte>()
            // Transaction ID
            query.addAll(listOf(0x12.toByte(), 0x34.toByte()))
            // Flags (Standard query)
            query.addAll(listOf(0x00.toByte(), 0x00.toByte()))
            // Questions: 1, Answers: 0, Authority: 0, Additional: 0
            query.addAll(listOf(0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))

            // Build QNAME
            for (part in arpa.split(".")) {
                query.add(part.length.toByte())
                query.addAll(part.toByteArray(Charsets.US_ASCII).toList())
            }
            query.add(0x00) // End of QNAME

            // QTYPE (PTR = 12), QCLASS (IN = 1)
            query.addAll(listOf(0x00, 0x0C, 0x00, 0x01))

            val queryArray = query.toByteArray()
            val addr = InetAddress.getByName(ip)
            socket.send(DatagramPacket(queryArray, queryArray.size, addr, 5355))

            val buf = ByteArray(1024)
            val recv = DatagramPacket(buf, buf.size)
            socket.receive(recv)
            socket.close()

            val data = recv.data
            // Very basic parse to extract hostname from the end of the PTR response
            val responseHex = data.copyOfRange(0, recv.length).joinToString("") { "%02x".format(it) }
            val partsString = String(data.copyOfRange(0, recv.length), Charsets.US_ASCII)
            
            // Extract the longest readable ASCII string at the end of the packet that isn't the .in-addr.arpa request
            val candidate = Regex("[a-zA-Z0-9\\-]{3,}").findAll(partsString).map { it.value }.filter { 
                !it.contains("in-addr") && !it.contains("arpa") && it.length > 2 
            }.lastOrNull()
            
            candidate ?: ""
        } catch (_: Exception) { "" }
    }

    // ═══════════════════════════════════════════════════════════════
    //  PORT-BASED DEVICE TYPE DETECTION
    // ═══════════════════════════════════════════════════════════════

    private fun getTtl(ip: String): Int {
        return try {
            val p = Runtime.getRuntime().exec("ping -c 1 -W 1 $ip")
            val out = BufferedReader(InputStreamReader(p.inputStream)).readText()
            p.waitFor()
            Regex("ttl=(\\d+)", RegexOption.IGNORE_CASE).find(out)?.groupValues?.get(1)?.toIntOrNull() ?: 0
        } catch (_: Exception) { 0 }
    }

    private fun guessDeviceType(ip: String): String {
        val portMap = mapOf(
            62078 to "iphone",     // Apple lockdownd
            548 to "mac",          // AFP (Apple)
            8008 to "chromecast",  // Chromecast
            8443 to "smarthub",    // Smart home hub
            9100 to "printer",     // Printer
            515 to "printer",      // LPD printer
            631 to "printer",      // IPP/CUPS
            445 to "pc",           // SMB (Windows file sharing)
            139 to "pc",           // NetBIOS session
            5353 to "smart",       // mDNS
            8080 to "iot",         // IoT / camera
            554 to "camera",       // RTSP
        )
        for ((port, hint) in portMap) {
            try {
                val s = Socket()
                s.connect(InetSocketAddress(ip, port), 150)
                s.close()
                Log.d(TAG, "Port $port open on $ip → $hint")
                return hint
            } catch (_: Exception) {}
        }
        return "unknown"
    }

    // ═══════════════════════════════════════════════════════════════
    //  SSDP / UPnP
    // ═══════════════════════════════════════════════════════════════

    private fun ssdpDiscover(): List<Map<String, String>> {
        val results = CopyOnWriteArrayList<Map<String, String>>()
        try {
            val ssdpAddr = InetAddress.getByName("239.255.255.250")
            val msg = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: ssdp:all\r\n\r\n"
            val socket = DatagramSocket(null)
            socket.reuseAddress = true; socket.broadcast = true; socket.soTimeout = 3000
            socket.send(DatagramPacket(msg.toByteArray(), msg.length, ssdpAddr, 1900))

            val seen = mutableSetOf<String>()
            val deadline = System.currentTimeMillis() + 3000
            while (System.currentTimeMillis() < deadline) {
                try {
                    val buf = ByteArray(4096)
                    val recv = DatagramPacket(buf, buf.size)
                    socket.receive(recv)
                    val ip = recv.address.hostAddress ?: ""; if (ip in seen) continue; seen.add(ip)
                    val resp = String(recv.data, 0, recv.length)
                    results.add(mapOf(
                        "ip" to ip,
                        "server" to (extractHeader(resp, "SERVER") ?: ""),
                        "location" to (extractHeader(resp, "LOCATION") ?: ""),
                        "st" to (extractHeader(resp, "ST") ?: ""),
                        "usn" to (extractHeader(resp, "USN") ?: "")
                    ))
                } catch (_: java.net.SocketTimeoutException) { break }
            }
            socket.close()
        } catch (e: Exception) { Log.e(TAG, "SSDP: ${e.message}") }
        return results.toList()
    }

    private fun extractHeader(r: String, h: String) = Regex("$h:\\s*(.*)", RegexOption.IGNORE_CASE).find(r)?.groupValues?.get(1)?.trim()

    // ═══════════════════════════════════════════════════════════════
    //  ARP / WIFI / UTILS
    // ═══════════════════════════════════════════════════════════════

    private fun readArpTable(): String {
        try { val f = java.io.File("/proc/net/arp"); if (f.exists() && f.canRead()) { val d = f.readText(); if (d.lines().size > 1) return d } } catch (_: Exception) {}
        try {
            val p = Runtime.getRuntime().exec("ip neigh show"); val lines = BufferedReader(InputStreamReader(p.inputStream)).readLines(); p.waitFor()
            val hdr = "IP address       HW type     Flags       HW address            Mask     Device"
            val conv = lines.mapNotNull { l -> val parts = l.trim().split("\\s+".toRegex()); if (parts.size >= 6 && parts.contains("lladdr")) { val mi = parts.indexOf("lladdr")+1; if (mi < parts.size) "${parts[0]}           0x1         ${if (parts.last() in listOf("REACHABLE","DELAY","STALE")) "0x2" else "0x0"}      ${parts[mi]}       *        ${parts[2]}" else null } else null }
            if (conv.isNotEmpty()) return (listOf(hdr) + conv).joinToString("\n")
        } catch (_: Exception) {}
        return ""
    }

    private fun getWifiInfoData(): Map<String, Any?> {
        val wm = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        var ssid = ""; var bssid: String? = null; var rssi = -1; var linkSpeed = -1; var frequency = -1
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                val net = cm.activeNetwork
                if (net != null) { val caps = cm.getNetworkCapabilities(net)
                    if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) { (caps.transportInfo as? android.net.wifi.WifiInfo)?.let { ssid = it.ssid?.removeSurrounding("\"") ?: ""; bssid = it.bssid; rssi = it.rssi; linkSpeed = it.linkSpeed; frequency = it.frequency } }
                        else { @Suppress("DEPRECATION") wm.connectionInfo.let { ssid = it.ssid?.removeSurrounding("\"") ?: ""; bssid = it.bssid; rssi = it.rssi; linkSpeed = it.linkSpeed; frequency = it.frequency } }
                    }
                }
                if (ssid.isBlank() || ssid == "<unknown ssid>") { @Suppress("DEPRECATION") wm.connectionInfo.let { val s = it.ssid?.removeSurrounding("\"") ?: ""; if (s.isNotBlank() && s != "<unknown ssid>") { ssid = s; bssid = it.bssid; rssi = it.rssi; linkSpeed = it.linkSpeed; frequency = it.frequency } } }
            } else { @Suppress("DEPRECATION") wm.connectionInfo.let { ssid = it.ssid?.removeSurrounding("\"") ?: ""; bssid = it.bssid; rssi = it.rssi; linkSpeed = it.linkSpeed; @Suppress("DEPRECATION") frequency = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) it.frequency else -1 } }
        } catch (e: Exception) { Log.e(TAG, "WiFi: ${e.message}") }
        if (ssid == "<unknown ssid>" || ssid == "0x") ssid = ""
        return mapOf("ssid" to ssid, "bssid" to bssid, "rssi" to rssi, "linkSpeed" to linkSpeed, "frequency" to frequency)
    }

    private fun intToIp(i: Int) = "${i and 0xFF}.${(i shr 8) and 0xFF}.${(i shr 16) and 0xFF}.${(i shr 24) and 0xFF}"
    private fun getLocalIpFallback(): String { try { for (intf in NetworkInterface.getNetworkInterfaces()) { if (intf.isLoopback || !intf.isUp) continue; for (a in intf.inetAddresses) { if (!a.isLoopbackAddress && a is Inet4Address) return a.hostAddress ?: "" } }; return "" } catch (_: Exception) { return "" } }
}
