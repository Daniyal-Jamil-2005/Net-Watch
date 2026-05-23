import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'security_scorer.g.dart';

@riverpod
int deviceSecurityScore(DeviceSecurityScoreRef ref, {
  required List<int> openPorts,
  required bool hasDefaultCreds,
  required bool isUnknownDevice,
  required bool hasHostname,
}) {
  int score = 100;
  
  if (openPorts.contains(23)) score -= 30; // Telnet
  if (openPorts.contains(21)) score -= 15; // FTP
  if (openPorts.contains(554)) score -= 10; // RTSP
  
  if (hasDefaultCreds) score -= 25;
  if (isUnknownDevice) score -= 10;
  if (!hasHostname) score -= 5;
  
  return score.clamp(0, 100);
}
