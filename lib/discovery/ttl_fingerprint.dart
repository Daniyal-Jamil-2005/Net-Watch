import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'ttl_fingerprint.g.dart';

enum OsFamily { linux, windows, router, unknown }

class TtlResult {
  final String ip;
  final OsFamily os;
  final int rawTtl;

  TtlResult(this.ip, this.os, this.rawTtl);
}

@riverpod
class TtlFingerprintScanner extends _$TtlFingerprintScanner {
  @override
  Future<List<TtlResult>> build() async => [];

  Future<void> scan(List<String> targetIps) async {
    state = const AsyncValue.loading();
    final results = <TtlResult>[];

    for (final ip in targetIps) {
        final ping = Ping(ip, count: 1, timeout: 1);
        try {
            final data = await ping.stream.firstWhere((event) => event.response != null, orElse: () => PingData());
            if (data.response != null && data.response!.ttl != null) {
                final ttl = data.response!.ttl!;
                OsFamily os = OsFamily.unknown;
                if (ttl > 0 && ttl <= 64) {
                    os = OsFamily.linux; // Linux, Android, iOS, macOS
                } else if (ttl > 64 && ttl <= 128) {
                    os = OsFamily.windows; // Windows
                } else if (ttl > 128 && ttl <= 255) {
                    os = OsFamily.router; // Network equipment
                }
                results.add(TtlResult(ip, os, ttl));
            }
        } catch (_) {}
    }
    state = AsyncValue.data(results);
  }
}
