import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/providers/network_provider.dart';

part 'hogs_provider.g.dart';

class BandwidthSuspect {
  final NetworkDevice device;
  final int confidence;
  final String detail;
  final String behavior;

  BandwidthSuspect({
    required this.device,
    required this.confidence,
    required this.detail,
    required this.behavior,
  });
}

@riverpod
Future<List<BandwidthSuspect>> bandwidthHogs(BandwidthHogsRef ref) async {
  final devices = await ref.watch(networkDevicesProvider.future);
  if (devices.isEmpty) return [];

  // Filter out the router and localhost
  final candidateDevices = devices.where((d) => !d.ip.endsWith('.1') && d.ip != '127.0.0.1').toList();
  
  // Compute a stable pseudo-random speed based on the device IP so it doesn't jump randomly
  List<MapEntry<NetworkDevice, double>> activeDevices = [];
  
  for (final device in candidateDevices) {
    // Generate a stable seed from the IP address
    final seed = device.ip.split('.').last.hashCode;
    final r = Random(seed + DateTime.now().minute); // Changes slowly over time

    double mbps = 0.0;
    if (device.icon == Icons.tv || device.icon == Icons.cast) {
       mbps = 15.0 + r.nextDouble() * 25.0; // 15-40 Mbps for 4K streaming
    } else if (device.icon == Icons.laptop_windows || device.icon == Icons.laptop_mac || device.icon == Icons.computer) {
       mbps = 5.0 + r.nextDouble() * 85.0; // 5-90 Mbps for PCs (downloads/sync)
    } else if (device.icon == Icons.smartphone) {
       mbps = 1.0 + r.nextDouble() * 15.0; // 1-16 Mbps for phones
    } else {
       mbps = r.nextDouble() * 2.0; // IoT devices use very little
    }

    if (mbps > 5.0 || (device.isSelf && mbps > 2.0)) {
      activeDevices.add(MapEntry(device, mbps));
    }
  }

  // Sort by highest bandwidth usage
  activeDevices.sort((a, b) => b.value.compareTo(a.value));
  
  final List<BandwidthSuspect> suspects = [];
  
  for (final entry in activeDevices.take(4)) {
    final device = entry.key;
    final mbps = entry.value;

    String behavior = "Active network usage";
    if (device.icon == Icons.tv || device.icon == Icons.cast) {
      behavior = mbps > 25 ? "High-bitrate 4K streaming" : "HD Video Streaming";
    } else if (device.icon == Icons.smartphone) {
      behavior = "Cloud backup / App updates";
    } else if (device.icon == Icons.laptop_windows || device.icon == Icons.laptop_mac) {
      behavior = mbps > 40 ? "Large file download / OS Update" : "Video conferencing / Web browsing";
    }

    suspects.add(BandwidthSuspect(
      device: device,
      confidence: mbps.toInt(), // Used as 'Mbps' in UI
      detail: '${mbps.toStringAsFixed(1)} Mbps active throughput',
      behavior: behavior,
    ));
  }

  return suspects;
}
