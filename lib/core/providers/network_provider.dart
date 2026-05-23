import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../discovery/mdns_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native/native_channels.dart';

part 'network_provider.g.dart';

class NetworkDevice {
  final String ip;
  final String mac;
  final String vendor;
  final String hostname;    // NetBIOS / rDNS / mDNS name
  final String osGuess;     // "Windows", "Android", "Router", etc.
  final String deviceType;  // "pc", "iphone", "chromecast", "router", "self", etc.
  final int ttl;
  final String ssdpServer;
  final bool isSelf;
  final String status;
  final IconData icon;

  NetworkDevice({
    required this.ip,
    this.mac = '',
    this.vendor = '',
    this.hostname = '',
    this.osGuess = 'Unknown',
    this.deviceType = 'unknown',
    this.ttl = 0,
    this.ssdpServer = '',
    this.isSelf = false,
    required this.status,
    required this.icon,
  });

  /// Best user-friendly display name
  String get displayName {
    // Self device
    if (isSelf) return hostname.isNotEmpty ? hostname : 'This Device';
    // NetBIOS / rDNS / mDNS hostname (the real prize)
    if (hostname.isNotEmpty) return _cleanHostname(hostname);
    // SSDP server string
    if (ssdpServer.isNotEmpty) return ssdpServer.split('/').first.trim();
    // Device type label
    return _labelForType(deviceType, osGuess);
  }

  /// Subtitle info — shows OS type
  String get displayOs => osGuess;

  String _cleanHostname(String raw) {
    return raw
        .replaceAll('.local', '')
        .replaceAll('.lan', '')
        .replaceAll('.home', '')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');
  }

  String _labelForType(String type, String os) {
    switch (type) {
      case 'router': return 'Router';
      case 'self': return 'This Device';
      case 'pc': return os == 'Windows' ? 'Windows PC' : 'Computer';
      case 'iphone': return 'iPhone';
      case 'mac': return 'Mac';
      case 'chromecast': return 'Chromecast';
      case 'printer': return 'Printer';
      case 'smarthub': return 'Smart Hub';
      case 'camera': return 'IP Camera';
      case 'iot': return 'IoT Device';
      case 'smart': return 'Smart Device';
      default:
        if (os == 'Windows') return 'Windows PC';
        if (os == 'Android' || os == 'Linux/Android') return 'Mobile / Smart Device';
        if (os.contains('Linux')) return 'Linux Device';
        if (os == 'Network Equipment') return 'Network Device';
        return 'Connected Device';
    }
  }
}

@riverpod
Future<String> wifiSsid(WifiSsidRef ref) async {
  final native = ref.read(nativeChannelsProvider);
  try {
    final info = await native.getWifiInfo().timeout(const Duration(seconds: 5));
    var ssid = info['ssid']?.toString().replaceAll('"', '') ?? '';
    if (ssid == '<unknown ssid>' || ssid == '0x' || ssid.isEmpty) ssid = '';
    return ssid.isEmpty ? 'Unknown Network' : ssid;
  } catch (_) { return 'Unknown Network'; }
}

@riverpod
Stream<double> networkSpeed(NetworkSpeedRef ref) async* {
  final native = ref.read(nativeChannelsProvider);
  int lastRx = 0;
  int lastTx = 0;
  int lastTime = DateTime.now().millisecondsSinceEpoch;

  while (true) {
    try {
      final stats = await native.getTrafficStats();
      final rx = (stats['rx'] as num).toInt();
      final tx = (stats['tx'] as num).toInt();
      final now = DateTime.now().millisecondsSinceEpoch;

      if (lastRx > 0 && lastTx > 0) {
        final rxDiff = rx - lastRx;
        final txDiff = tx - lastTx;
        final timeDiff = (now - lastTime) / 1000.0;
        
        if (timeDiff > 0) {
          // Total bytes per second
          final bytesPerSec = (rxDiff + txDiff) / timeDiff;
          // Convert bytes/sec to Megabits/sec (Mbps)
          final mbps = (bytesPerSec * 8) / 1000000;
          yield mbps < 0 ? 0.0 : mbps;
        }
      }

      lastRx = rx;
      lastTx = tx;
      lastTime = now;
    } catch (_) {}
    await Future.delayed(const Duration(seconds: 1));
  }
}

@Riverpod(keepAlive: true)
Future<List<NetworkDevice>> networkDevices(NetworkDevicesRef ref) async {
  final native = ref.read(nativeChannelsProvider);
  final Map<String, NetworkDevice> deviceMap = {};

  // ═══ 1. Ping sweep (TTL + hostname + port hints) ═══════════════
  debugPrint('[NET] Starting discovery...');
  try {
    final discovered = await native.discoverDevices()
        .timeout(const Duration(seconds: 20));
    debugPrint('[NET] Ping sweep: ${discovered.length} hosts');

    for (final d in discovered) {
      final ip = d['ip']?.toString() ?? '';
      if (ip.isEmpty) continue;

      final hostname = d['hostname']?.toString() ?? '';
      final osGuess = d['osGuess']?.toString() ?? 'Unknown';
      final deviceType = d['deviceType']?.toString() ?? 'unknown';
      final ttl = (d['ttl'] as int?) ?? 0;
      final isGateway = d['isGateway'] == true;
      final isSelf = d['isSelf'] == true;

      deviceMap[ip] = NetworkDevice(
        ip: ip,
        hostname: hostname,
        osGuess: osGuess,
        deviceType: isGateway ? 'router' : deviceType,
        ttl: ttl,
        isSelf: isSelf,
        status: 'active',
        icon: _iconForDevice(isGateway ? 'router' : deviceType, osGuess, isSelf),
      );
    }
  } catch (e) {
    debugPrint('[NET] Discovery failed: $e');
  }

  // ═══ 2. SSDP enrichment ════════════════════════════════════════
  try {
    final ssdp = await native.ssdpDiscover().timeout(const Duration(seconds: 5));
    debugPrint('[NET] SSDP: ${ssdp.length} responses');
    for (final s in ssdp) {
      final ip = s['ip']?.toString() ?? '';
      if (ip.isEmpty) continue;
      final server = s['server']?.toString() ?? '';
      final st = s['st']?.toString() ?? '';
      if (deviceMap.containsKey(ip)) {
        final e = deviceMap[ip]!;
        deviceMap[ip] = NetworkDevice(
          ip: ip, hostname: e.hostname, osGuess: e.osGuess,
          deviceType: _ssdpType(server, st, e.deviceType),
          ttl: e.ttl, ssdpServer: server, isSelf: e.isSelf,
          status: 'active', icon: _ssdpIcon(server, st, e.icon),
        );
      }
    }
  } catch (_) {}

  // ═══ 3. mDNS enrichment ════════════════════════════════════════
  try {
    ref.read(mdnsScannerProvider).whenData((records) {
      for (final rec in records) {
        if (deviceMap.containsKey(rec.ip)) {
          final e = deviceMap[rec.ip]!;
          // mDNS hostname beats everything except self
          if (!e.isSelf && rec.hostname.isNotEmpty) {
            deviceMap[rec.ip] = NetworkDevice(
              ip: rec.ip, hostname: rec.hostname,
              osGuess: e.osGuess, deviceType: e.deviceType,
              ttl: e.ttl, ssdpServer: e.ssdpServer, isSelf: e.isSelf,
              status: 'active', icon: _mdnsIcon(rec.hostname, e.icon),
            );
          }
        } else {
          deviceMap[rec.ip] = NetworkDevice(
            ip: rec.ip, hostname: rec.hostname,
            status: 'active', icon: _mdnsIcon(rec.hostname, Icons.device_unknown),
          );
        }
      }
    });
  } catch (_) {}

  // Sort: self first, then router, then alphabetically by displayName
  final devices = deviceMap.values.toList()
    ..sort((a, b) {
      if (a.isSelf) return -1;
      if (b.isSelf) return 1;
      if (a.deviceType == 'router') return -1;
      if (b.deviceType == 'router') return 1;
      return a.displayName.compareTo(b.displayName);
    });

  debugPrint('[NET] Final: ${devices.length} devices');
  return devices;
}

IconData _iconForDevice(String type, String os, bool isSelf) {
  if (isSelf) return Icons.smartphone;
  switch (type) {
    case 'router': return Icons.router;
    case 'pc': return Icons.laptop_windows;
    case 'iphone': return Icons.phone_iphone;
    case 'mac': return Icons.laptop_mac;
    case 'chromecast': return Icons.cast;
    case 'printer': return Icons.print;
    case 'smarthub': return Icons.smart_toy;
    case 'camera': return Icons.videocam;
    case 'iot': return Icons.sensors;
    case 'smart': return Icons.smart_toy;
    default:
      if (os == 'Windows') return Icons.laptop_windows;
      if (os == 'Android' || os == 'Linux/Android') return Icons.smartphone;
      if (os.contains('Linux')) return Icons.computer;
      if (os == 'Network Equipment') return Icons.settings_ethernet;
      return Icons.device_unknown;
  }
}

IconData _ssdpIcon(String server, String st, IconData fallback) {
  final s = '$server $st'.toLowerCase();
  if (s.contains('chromecast') || s.contains('cast')) return Icons.cast;
  if (s.contains('tv') || s.contains('samsung') || s.contains('lg') || s.contains('roku')) return Icons.tv;
  if (s.contains('sonos') || s.contains('speaker')) return Icons.speaker;
  if (s.contains('hue') || s.contains('lifx') || s.contains('light')) return Icons.lightbulb;
  return fallback;
}

IconData _mdnsIcon(String hostname, IconData fallback) {
  final h = hostname.toLowerCase();
  if (h.contains('iphone') || h.contains('ipad')) return Icons.phone_iphone;
  if (h.contains('macbook') || h.contains('imac') || h.contains('mac')) return Icons.laptop_mac;
  if (h.contains('chromecast')) return Icons.cast;
  if (h.contains('printer') || h.contains('epson') || h.contains('hp')) return Icons.print;
  if (h.contains('tv')) return Icons.tv;
  return fallback;
}

String _ssdpType(String server, String st, String fallback) {
  final s = '$server $st'.toLowerCase();
  if (s.contains('chromecast') || s.contains('cast')) return 'chromecast';
  if (s.contains('tv') || s.contains('roku')) return 'tv';
  if (s.contains('printer')) return 'printer';
  return fallback;
}
