import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'netbios_service.g.dart';

class NetbiosResult {
  final String ip;
  final String hostname;
  final String workgroup;

  NetbiosResult(this.ip, this.hostname, this.workgroup);
}

@riverpod
class NetbiosScanner extends _$NetbiosScanner {
  @override
  Future<List<NetbiosResult>> build() async => [];

  Future<void> scan(List<String> targetIps) async {
    state = const AsyncValue.loading();
    final results = <NetbiosResult>[];
    
    try {
      final RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.readEventsEnabled = true;

      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null && datagram.data.length > 57) {
             final data = datagram.data;
             int offset = 57;
             String hostname = "";
             while (offset < data.length && data[offset] != 0x00 && data[offset] != 0x20) {
                 hostname += String.fromCharCode(data[offset]);
                 offset++;
             }
             if (hostname.isNotEmpty) {
                 results.add(NetbiosResult(datagram.address.address, hostname.trim(), "WORKGROUP"));
             }
          }
        }
      });

      final queryPacket = [
        0x82, 0x28, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x20, 0x43, 0x4b, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41,
        0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41,
        0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x00, 0x00, 0x21,
        0x00, 0x01
      ];

      for (final ip in targetIps) {
         try {
             socket.send(queryPacket, InternetAddress(ip), 137);
         } catch (_) {}
      }

      await Future.delayed(const Duration(seconds: 2));
      socket.close();
    } catch (_) {}
    
    state = AsyncValue.data(results);
  }
}
