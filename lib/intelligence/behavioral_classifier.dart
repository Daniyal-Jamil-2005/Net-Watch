import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'behavioral_classifier.g.dart';

@riverpod
String classifyDeviceBehavior(ClassifyDeviceBehaviorRef ref, {
  required double txRate, 
  required double rxRate,
  required double pingVariance
}) {
  if (rxRate > 5000000 && txRate < 500000) return "Streaming/Download";
  if (rxRate > 100000 && txRate > 100000 && pingVariance < 10) return "Call/Meeting";
  if (rxRate < 10000 && txRate < 10000) return "Idle";
  return "Unknown Activity";
}
