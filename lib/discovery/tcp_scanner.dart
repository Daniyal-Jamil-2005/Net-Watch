import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'tcp_scanner.g.dart';

class TcpScanResult {
  final String ip;
  final int port;
  final bool isOpen;

  TcpScanResult(this.ip, this.port, this.isOpen);
}

@riverpod
class TcpScanner extends _$TcpScanner {
  @override
  Future<List<TcpScanResult>> build() async => [];

  Future<void> scanSubnet(String subnet, {List<int> ports = const [80, 443, 22, 7]}) async {
    final results = <TcpScanResult>[];
    state = const AsyncValue.loading();
    
    final ips = List.generate(254, (i) => '$subnet.${i + 1}');
    final queue = <Function>[];
    
    for (final ip in ips) {
      for (final port in ports) {
        queue.add(() => _checkPort(ip, port).then((res) {
          if (res != null) results.add(res);
        }));
      }
    }
    
    await _throttledExecute(queue, 30);
    state = AsyncValue.data(results);
  }

  Future<TcpScanResult?> _checkPort(String ip, int port) async {
    try {
      final socket = await Socket.connect(ip, port, timeout: const Duration(milliseconds: 300));
      socket.destroy();
      return TcpScanResult(ip, port, true);
    } catch (_) {
      return null;
    }
  }

  Future<void> _throttledExecute(List<Function> tasks, int concurrency) async {
    int i = 0;
    while (i < tasks.length) {
      final chunk = <Future>[];
      for (var j = 0; j < concurrency && i < tasks.length; j++, i++) {
        chunk.add(tasks[i]());
      }
      await Future.wait(chunk);
    }
  }
}
