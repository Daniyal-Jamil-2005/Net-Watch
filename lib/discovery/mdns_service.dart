import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/native/native_channels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'mdns_service.g.dart';

class MdnsDevice {
  final String hostname;
  final String ip;
  final List<String> services;

  MdnsDevice(this.hostname, this.ip, this.services);

  /// Clean hostname for display
  String get displayHostname {
    return hostname
        .replaceAll('.local.', '')
        .replaceAll('.local', '')
        .replaceAll('._tcp', '')
        .replaceAll('._udp', '')
        .trim();
  }
}

@riverpod
class MdnsScanner extends _$MdnsScanner {
  @override
  Future<List<MdnsDevice>> build() async => [];

  Future<void> scan() async {
    final native = ref.read(nativeChannelsProvider);
    state = const AsyncValue.loading();

    await native.acquireMulticastLock();

    final devices = <String, MdnsDevice>{};
    MDnsClient? client;

    try {
      client = MDnsClient();
      await client.start();

      // ══════════════════════════════════════════════════════════
      // Query ALL common mDNS service types to find every device
      // ══════════════════════════════════════════════════════════
      final serviceTypes = [
        // Apple devices (iPhone, iPad, Mac, Apple TV, HomePod)
        '_airplay._tcp.local',
        '_raop._tcp.local',         // Remote Audio Output (AirPlay audio)
        '_companion-link._tcp.local', // Apple Continuity
        '_homekit._tcp.local',      // HomeKit accessories
        '_airdrop._tcp.local',

        // Chromecast / Google devices
        '_googlecast._tcp.local',
        '_googlerpc._tcp.local',

        // Smart speakers & media
        '_spotify-connect._tcp.local',
        '_sonos._tcp.local',

        // Printers
        '_ipp._tcp.local',          // Internet Printing Protocol
        '_ipps._tcp.local',         // IPP Secure
        '_printer._tcp.local',
        '_pdl-datastream._tcp.local', // PCL/PS printers
        '_scanner._tcp.local',

        // File sharing / computers
        '_smb._tcp.local',          // Windows/Samba shares
        '_afpovertcp._tcp.local',   // Apple File Protocol
        '_nfs._tcp.local',
        '_sftp-ssh._tcp.local',
        '_ssh._tcp.local',          // SSH servers (Linux/Mac)
        '_rdp._tcp.local',          // Remote Desktop (Windows)

        // Web / HTTP services
        '_http._tcp.local',
        '_https._tcp.local',
        '_hap._tcp.local',          // HomeKit Accessory Protocol

        // Smart home / IoT
        '_hue._tcp.local',          // Philips Hue
        '_matter._tcp.local',       // Matter protocol
        '_esphomelib._tcp.local',   // ESPHome devices
        '_mqtt._tcp.local',

        // Media servers
        '_daap._tcp.local',         // iTunes shared library
        '_dpap._tcp.local',         // iPhoto shared library
        '_roku-rcp._tcp.local',     // Roku
        '_mediarenderer._tcp.local',

        // Android devices
        '_adb-tls-connect._tcp.local', // Android Debug Bridge
        '_androidtvremote2._tcp.local', // Android TV

        // Generic
        '_device-info._tcp.local',  // Device info service
        '_workstation._tcp.local',  // Avahi workstation
        '_services._dns-sd._udp.local', // Browse all services
      ];

      for (final svc in serviceTypes) {
        try {
          await for (final PtrResourceRecord ptr
              in client.lookup<PtrResourceRecord>(
                  ResourceRecordQuery.serverPointer(svc))
                  .timeout(const Duration(seconds: 2))) {

            try {
              await for (final SrvResourceRecord srv
                  in client.lookup<SrvResourceRecord>(
                      ResourceRecordQuery.service(ptr.domainName))
                      .timeout(const Duration(seconds: 2))) {

                try {
                  await for (final IPAddressResourceRecord ipRec
                      in client.lookup<IPAddressResourceRecord>(
                          ResourceRecordQuery.addressIPv4(srv.target))
                          .timeout(const Duration(seconds: 2))) {

                    final ip = ipRec.address.address;
                    final hostname = srv.target;
                    debugPrint('[mDNS] Found: $hostname ($ip) via $svc');

                    if (devices.containsKey(ip)) {
                      if (!devices[ip]!.services.contains(svc)) {
                        devices[ip]!.services.add(svc);
                      }
                      // Update hostname if this one is better (more specific)
                      if (hostname.length > devices[ip]!.hostname.length) {
                        devices[ip] = MdnsDevice(hostname, ip, devices[ip]!.services);
                      }
                    } else {
                      devices[ip] = MdnsDevice(hostname, ip, [svc]);
                    }
                  }
                } on TimeoutException catch (_) {}
              }
            } on TimeoutException catch (_) {}
          }
        } on TimeoutException catch (_) {
          // Service type not found on network — skip silently
        } catch (e) {
          debugPrint('[mDNS] Error scanning $svc: $e');
        }
      }
    } catch (e) {
      debugPrint('[mDNS] Fatal error: $e');
    } finally {
      try { client?.stop(); } catch (_) {}
      await native.releaseMulticastLock();
    }

    debugPrint('[mDNS] Scan complete: ${devices.length} devices found');
    for (final d in devices.values) {
      debugPrint('[mDNS]   ${d.hostname} (${d.ip}) — ${d.services.join(", ")}');
    }

    state = AsyncValue.data(devices.values.toList());
  }
}
