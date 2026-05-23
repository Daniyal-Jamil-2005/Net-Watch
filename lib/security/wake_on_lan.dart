import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'wake_on_lan.g.dart';

@riverpod
class WakeOnLan extends _$WakeOnLan {
  @override
  bool build() => false;

  Future<void> wake(String macAddress) async {
    final cleanMac = macAddress.replaceAll(':', '').replaceAll('-', '').toUpperCase();
    if (cleanMac.length != 12) return;
    
    final payload = <int>[];
    for (int i = 0; i < 6; i++) payload.add(0xFF);
    
    final macBytes = <int>[];
    for (int i = 0; i < 12; i += 2) {
       macBytes.add(int.parse(cleanMac.substring(i, i+2), radix: 16));
    }
    
    for (int i = 0; i < 16; i++) {
        payload.addAll(macBytes);
    }
    
    try {
        final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
        socket.broadcastEnabled = true;
        socket.send(payload, InternetAddress("255.255.255.255"), 9);
        socket.close();
    } catch (_) {}
  }
}
