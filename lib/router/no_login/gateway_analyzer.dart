import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'gateway_analyzer.g.dart';

@riverpod
class GatewayAnalyzer extends _$GatewayAnalyzer {
  @override
  Future<String> build() async => "Unknown";

  Future<String> analyze(String gatewayIp, String gatewayMac, int gatewayTtl) async {
    state = const AsyncValue.loading();
    // Basic heuristic 
    String result = "Unknown Router OS";
    if (gatewayTtl > 128 && gatewayTtl <= 255) {
       result = "Enterprise Router";
    } else if (gatewayTtl > 0 && gatewayTtl <= 64) {
       result = "Linux-based Firmware (OpenWRT/Custom)";
    }
    state = AsyncValue.data(result);
    return result;
  }
}
