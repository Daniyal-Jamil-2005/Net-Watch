import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'rogue_detector.g.dart';

@riverpod
bool isRogueDevice(IsRogueDeviceRef ref, String macAddress) {
  // Compares MAC against known_devices table in sqflite
  // Stubbed implementation
  return false; 
}
