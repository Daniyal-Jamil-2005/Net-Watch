import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'ping_engine.g.dart';

class PingStats {
  final String target;
  final double latency;
  final double jitter;
  final double packetLoss;

  PingStats(this.target, this.latency, this.jitter, this.packetLoss);
}

@riverpod
class PingEngine extends _$PingEngine {
  final Map<String, Ping> _pings = {};
  final Map<String, List<double>> _history = {};
  
  @override
  Stream<Map<String, PingStats>> build() async* {
    final targets = ['192.168.0.1', '8.8.8.8'];
    final Map<String, PingStats> currentStats = {};

    for (final target in targets) {
      _history[target] = [];
      _pings[target] = Ping(target, interval: 2);
      
      _pings[target]!.stream.listen((event) {
        if (event.response != null && event.response!.time != null) {
          final ms = event.response!.time!.inMilliseconds.toDouble();
          _history[target]!.add(ms);
          if (_history[target]!.length > 10) _history[target]!.removeAt(0);

          double jitter = 0;
          if (_history[target]!.length > 1) {
            double sum = 0;
            for (int i = 1; i < _history[target]!.length; i++) {
              sum += (_history[target]![i] - _history[target]![i - 1]).abs();
            }
            jitter = sum / (_history[target]!.length - 1);
          }

          currentStats[target] = PingStats(target, ms, jitter, 0.0);
        }
      });
    }

    // Yield updates periodically
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield Map.of(currentStats);
    }
  }

  void stop() {
    for (final ping in _pings.values) {
      ping.stop();
    }
  }
}
