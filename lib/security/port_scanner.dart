import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'port_scanner.g.dart';

@riverpod
Future<List<int>> openPorts(OpenPortsRef ref, String ip) async {
  final portsToCheck = [21, 22, 23, 80, 443, 554, 8080, 8443, 49000];
  final open = <int>[];
  for (final port in portsToCheck) {
     try {
         final socket = await Socket.connect(ip, port, timeout: const Duration(milliseconds: 300));
         open.add(port);
         socket.destroy();
     } catch (_) {}
  }
  return open;
}
