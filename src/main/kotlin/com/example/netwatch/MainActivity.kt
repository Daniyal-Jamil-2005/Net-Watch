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
import java.io.File
import java.io.InputStreamReader
import java.net.Inet4Address
import java.net.InetAddress
import java.net.NetworkInterface

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.netwatch/native"
    private val TAG = "NetWatch"
    private var multicastLock: WifiManager.MulticastLock? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getArpTable" -> {
                    try {
                        // Try /proc/net/arp first (works on Android < 10)
                        val procArp = File("/proc/net/arp")
                        var arpData = ""
                        if (procArp.exists() && procArp.canRead()) {
                            arpData = procArp.readText()
                            Log.d(TAG, "Read /proc/net/arp: ${arpData.length} bytes")
                        }

                        // If /proc/net/arp is empty or blocked (Android 10+), use `ip neigh`
                        if (arpData.isBlank() || arpData.lines().size <= 1) {
                            Log.d(TAG, "/proc/net/arp empty or restricted, trying 'ip neigh show'")
                            arpData = getArpFromIpNeigh()
                        }

                        // If still empty, do a quick subnet ping to populate the ARP cache
                        if (arpData.isBlank() || arpData.lines().size <= 1) {
                            Log.d(TAG, "ARP still empty, running subnet ping sweep")
                            pingSubnet()
                            // Re-read after pinging
                            arpData = getArpFromIpNeigh()
                            if (arpData.isBlank() || arpData.lines().size <= 1) {
                                // Try /proc/net/arp again after pinging
                                if (procArp.exists() && procArp.canRead()) {
                                    arpData = procArp.readText()
                                }
                            }
                        }

                        Log.d(TAG, "Final ARP data: ${arpData.length} bytes, ${arpData.lines().size} lines")
                        result.success(arpData)
                    } catch (e: Exception) {
                        Log.e(TAG, "ARP failed: ${e.message}")
                        result.error("UNAVAILABLE", "Cannot read ARP table: ${e.message}", null)
                    }
                }

                "getTrafficStats" -> {
                    val uid = call.argument<Int>("uid")
                    if (uid != null) {
                        val rx = TrafficStats.getUidRxBytes(uid)
                        val tx = TrafficStats.getUidTxBytes(uid)
                        result.success(mapOf("rx" to rx, "tx" to tx))
                    } else {
                        val rx = TrafficStats.getTotalRxBytes()
                        val tx = TrafficStats.getTotalTxBytes()
                        result.success(mapOf("rx" to rx, "tx" to tx))
                    }
                }

                "getUsageStats" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        val usageStatsManager =
                            context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
                        val endTime = System.currentTimeMillis()
                        val startTime = endTime - (1000 * 60 * 60 * 24)
                        val stats = usageStatsManager.queryUsageStats(
                            UsageStatsManager.INTERVAL_DAILY, startTime, endTime
                        )
                        val resultList = stats?.map {
                            mapOf(
                                "packageName" to it.packageName,
                                "totalTimeInForeground" to it.totalTimeInForeground
                            )
                        } ?: emptyList()
                        result.success(resultList)
                    } else {
                        result.error("UNSUPPORTED", "Requires Android 5.0+", null)
                    }
                }

                "getNetworkInterfaces" -> {
                    try {
                        val interfaces = NetworkInterface.getNetworkInterfaces()
                        val list = mutableListOf<Map<String, Any>>()
                        for (intf in interfaces) {
                            val addresses = mutableListOf<Map<String, String>>()
                            for (addr in intf.interfaceAddresses) {
                                addresses.add(
                                    mapOf(
                                        "address" to (addr.address.hostAddress ?: ""),
                                        "prefixLength" to addr.networkPrefixLength.toString()
                                    )
                                )
                            }
                            list.add(mapOf("name" to intf.name, "addresses" to addresses))
                        }
                        result.success(list)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }

                "acquireMulticastLock" -> {
                    if (multicastLock == null) {
                        val wifiManager =
                            context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                        multicastLock = wifiManager.createMulticastLock("netwatch_multicast_lock")
                        multicastLock?.setReferenceCounted(true)
                    }
                    multicastLock?.acquire()
                    result.success(true)
                }

                "releaseMulticastLock" -> {
                    if (multicastLock != null && multicastLock!!.isHeld) {
                        multicastLock?.release()
                    }
                    result.success(true)
                }

                "getWifiInfo" -> {
                    val data = getWifiInfoData()
                    result.success(data)
                }

                "getDeviceInfo" -> {
                    val wifiManager =
                        context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    @Suppress("DEPRECATION")
                    val ipInt = wifiManager.connectionInfo.ipAddress
                    val ipStr = if (ipInt != 0) intToIp(ipInt) else getLocalIpFallback()
                    result.success(mapOf("model" to Build.MODEL, "ip" to ipStr))
                }

                else -> result.notImplemented()
            }
        }
    }

    /**
     * Read ARP neighbors via `ip neigh show` command.
     * Returns data in /proc/net/arp format for compatibility with the Dart parser.
     */
    private fun getArpFromIpNeigh(): String {
        return try {
            val process = Runtime.getRuntime().exec("ip neigh show")
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val lines = reader.readLines()
            reader.close()
            process.waitFor()
            Log.d(TAG, "ip neigh returned ${lines.size} lines")

            // Convert "ip neigh" output to /proc/net/arp format:
            // ip neigh: "192.168.0.1 dev wlan0 lladdr aa:bb:cc:dd:ee:ff REACHABLE"
            // proc/arp: "IP address  HW type  Flags  HW address  Mask  Device"
            val header = "IP address       HW type     Flags       HW address            Mask     Device"
            val converted = lines.mapNotNull { line ->
                val parts = line.trim().split("\\s+".toRegex())
                // Typical: 192.168.0.1 dev wlan0 lladdr aa:bb:cc:dd:ee:ff REACHABLE
                if (parts.size >= 6 && parts.contains("lladdr")) {
                    val ip = parts[0]
                    val device = parts[2]
                    val macIndex = parts.indexOf("lladdr") + 1
                    if (macIndex < parts.size) {
                        val mac = parts[macIndex]
                        val state = parts.last()
                        val flags = if (state == "REACHABLE" || state == "DELAY" || state == "STALE") "0x2" else "0x0"
                        "$ip           0x1         $flags      $mac       *        $device"
                    } else null
                } else null
            }

            if (converted.isEmpty()) {
                Log.d(TAG, "No valid entries from ip neigh")
                ""
            } else {
                Log.d(TAG, "Converted ${converted.size} entries from ip neigh")
                (listOf(header) + converted).joinToString("\n")
            }
        } catch (e: Exception) {
            Log.e(TAG, "ip neigh failed: ${e.message}")
            ""
        }
    }

    /**
     * Ping sweep the local subnet to force ARP cache population.
     * Only pings .1 through .30 for speed (covers most home networks).
     */
    private fun pingSubnet() {
        try {
            val wifiManager =
                context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            @Suppress("DEPRECATION")
            val ipInt = wifiManager.connectionInfo.ipAddress
            if (ipInt == 0) return

            val ip = intToIp(ipInt)
            val subnet = ip.substringBeforeLast(".")
            Log.d(TAG, "Ping sweeping subnet: $subnet.x")

            val threads = mutableListOf<Thread>()
            for (i in 1..30) {
                val targetIp = "$subnet.$i"
                val t = Thread {
                    try {
                        InetAddress.getByName(targetIp).isReachable(300)
                    } catch (_: Exception) { }
                }
                threads.add(t)
                t.start()
            }
            // Wait for all pings to finish
            for (t in threads) {
                try { t.join(500) } catch (_: Exception) { }
            }
            Log.d(TAG, "Ping sweep complete")
        } catch (e: Exception) {
            Log.e(TAG, "Ping sweep failed: ${e.message}")
        }
    }

    /**
     * Returns Wi-Fi SSID correctly on all Android versions.
     */
    private fun getWifiInfoData(): Map<String, Any?> {
        val wifiManager =
            context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

        var ssid = ""
        var bssid: String? = null
        var rssi = -1
        var linkSpeed = -1
        var frequency = -1

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                val activeNetwork = cm.activeNetwork
                if (activeNetwork != null) {
                    val caps = cm.getNetworkCapabilities(activeNetwork)
                    if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val wifiInfo = caps.transportInfo as? android.net.wifi.WifiInfo
                            if (wifiInfo != null) {
                                ssid = wifiInfo.ssid?.removeSurrounding("\"") ?: ""
                                bssid = wifiInfo.bssid
                                rssi = wifiInfo.rssi
                                linkSpeed = wifiInfo.linkSpeed
                                frequency = wifiInfo.frequency
                            }
                        } else {
                            @Suppress("DEPRECATION")
                            val info = wifiManager.connectionInfo
                            ssid = info.ssid?.removeSurrounding("\"") ?: ""
                            bssid = info.bssid
                            rssi = info.rssi
                            linkSpeed = info.linkSpeed
                            frequency = info.frequency
                        }
                    }
                }

                // Fallback: if ConnectivityManager didn't give us SSID, try legacy
                if (ssid.isBlank() || ssid == "<unknown ssid>") {
                    @Suppress("DEPRECATION")
                    val legacyInfo = wifiManager.connectionInfo
                    val legacySsid = legacyInfo.ssid?.removeSurrounding("\"") ?: ""
                    if (legacySsid.isNotBlank() && legacySsid != "<unknown ssid>") {
                        ssid = legacySsid
                        bssid = legacyInfo.bssid
                        rssi = legacyInfo.rssi
                        linkSpeed = legacyInfo.linkSpeed
                        frequency = legacyInfo.frequency
                    }
                }
            } else {
                @Suppress("DEPRECATION")
                val info = wifiManager.connectionInfo
                ssid = info.ssid?.removeSurrounding("\"") ?: ""
                bssid = info.bssid
                rssi = info.rssi
                linkSpeed = info.linkSpeed
                @Suppress("DEPRECATION")
                frequency = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) info.frequency else -1
            }
        } catch (e: Exception) {
            Log.e(TAG, "getWifiInfo error: ${e.message}")
        }

        if (ssid == "<unknown ssid>" || ssid == "0x") ssid = ""
        Log.d(TAG, "getWifiInfo returning ssid='$ssid'")

        return mapOf(
            "ssid" to ssid,
            "bssid" to bssid,
            "rssi" to rssi,
            "linkSpeed" to linkSpeed,
            "frequency" to frequency
        )
    }

    private fun intToIp(ipInt: Int): String {
        return "${ipInt and 0xFF}.${(ipInt shr 8) and 0xFF}.${(ipInt shr 16) and 0xFF}.${(ipInt shr 24) and 0xFF}"
    }

    private fun getLocalIpFallback(): String {
        return try {
            val interfaces = NetworkInterface.getNetworkInterfaces()
            for (intf in interfaces) {
                if (intf.isLoopback || !intf.isUp) continue
                for (addr in intf.inetAddresses) {
                    if (!addr.isLoopbackAddress && addr is Inet4Address) {
                        return addr.hostAddress ?: ""
                    }
                }
            }
            ""
        } catch (e: Exception) {
            ""
        }
    }
}
