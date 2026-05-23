import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'native_channels.g.dart';

class NativeChannels {
  static const MethodChannel _channel = MethodChannel('com.example.netwatch/native');

  Future<String> getArpTable() async {
    try {
      return await _channel.invokeMethod('getArpTable') ?? "";
    } catch (_) { return ""; }
  }

  /// Full subnet ping sweep with TTL, hostname, port hints, and OS guess.
  Future<List<Map<dynamic, dynamic>>> discoverDevices() async {
    try {
      return await _channel.invokeListMethod<Map<dynamic, dynamic>>('discoverDevices') ?? [];
    } catch (_) { return []; }
  }

  /// SSDP/UPnP M-SEARCH discovery (smart TVs, Chromecasts, IoT).
  Future<List<Map<dynamic, dynamic>>> ssdpDiscover() async {
    try {
      return await _channel.invokeListMethod<Map<dynamic, dynamic>>('ssdpDiscover') ?? [];
    } catch (_) { return []; }
  }

  Future<Map<dynamic, dynamic>> getTrafficStats({int? uid}) async {
    try {
      return await _channel.invokeMethod<Map<dynamic, dynamic>>('getTrafficStats', {'uid': uid}) ?? {'rx': 0, 'tx': 0};
    } catch (_) { return {'rx': 0, 'tx': 0}; }
  }

  Future<List<Map<dynamic, dynamic>>> getUsageStats() async {
    try {
      return await _channel.invokeListMethod<Map<dynamic, dynamic>>('getUsageStats') ?? [];
    } catch (_) { return []; }
  }

  Future<List<Map<dynamic, dynamic>>> getNetworkInterfaces() async {
    try {
      return await _channel.invokeListMethod<Map<dynamic, dynamic>>('getNetworkInterfaces') ?? [];
    } catch (_) { return []; }
  }

  Future<bool> acquireMulticastLock() async {
    try { return await _channel.invokeMethod<bool>('acquireMulticastLock') ?? false; }
    catch (_) { return false; }
  }

  Future<bool> releaseMulticastLock() async {
    try { return await _channel.invokeMethod<bool>('releaseMulticastLock') ?? false; }
    catch (_) { return false; }
  }

  Future<Map<dynamic, dynamic>> getWifiInfo() async {
    try { return await _channel.invokeMapMethod<dynamic, dynamic>('getWifiInfo') ?? {}; }
    catch (_) { return {}; }
  }

  Future<Map<dynamic, dynamic>> getDeviceInfo() async {
    try { return await _channel.invokeMapMethod<dynamic, dynamic>('getDeviceInfo') ?? {}; }
    catch (_) { return {}; }
  }
}

@Riverpod(keepAlive: true)
NativeChannels nativeChannels(NativeChannelsRef ref) {
  return NativeChannels();
}
