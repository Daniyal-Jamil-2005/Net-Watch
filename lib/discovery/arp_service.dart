import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/native/native_channels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'arp_service.g.dart';

class ArpEntry {
  final String ip;
  final String hwType;
  final String flags;
  final String mac;
  final String mask;
  final String device;

  ArpEntry({
    required this.ip,
    required this.hwType,
    required this.flags,
    required this.mac,
    required this.mask,
    required this.device,
  });

  bool get isReachable => flags.contains('0x2');
}

@riverpod
Future<List<ArpEntry>> arpTable(ArpTableRef ref) async {
  final native = ref.read(nativeChannelsProvider);
  final arpString = await native.getArpTable();
  debugPrint('[ARP] Raw ARP table length: ${arpString.length}');
  if (arpString.isEmpty) return [];

  final lines = arpString.split('\n');
  debugPrint('[ARP] Lines in ARP table: ${lines.length}');
  final entries = <ArpEntry>[];

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    // Split on one or more whitespace characters
    final parts = line.split(RegExp('\\s+'));
    if (parts.length >= 6) {
      if (parts[3] != '00:00:00:00:00:00') {
        entries.add(ArpEntry(
          ip: parts[0],
          hwType: parts[1],
          flags: parts[2],
          mac: parts[3].toUpperCase(),
          mask: parts[4],
          device: parts[5],
        ));
      }
    }
  }
  debugPrint('[ARP] Parsed ${entries.length} devices from ARP table');
  return entries;
}
