import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'mac_vendor_service.g.dart';

@Riverpod(keepAlive: true)
class MacVendorService extends _$MacVendorService {
  Map<String, String>? _db;

  @override
  Future<void> build() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/oui_db.json');
      final Map<String, dynamic> raw = jsonDecode(jsonStr);
      _db = raw.map((k, v) => MapEntry(k.toUpperCase(), v.toString()));
    } catch (e) {
       _db = {};
    }
  }

  String getVendor(String mac) {
    if (_db == null || _db!.isEmpty) return 'Unknown';
    if (mac.length < 8) return 'Unknown';
    // Clean MAC
    final clean = mac.replaceAll(':', '').replaceAll('-', '').toUpperCase();
    if (clean.length < 6) return 'Unknown';
    final prefix = clean.substring(0, 6);
    return _db![prefix] ?? 'Unknown';
  }
}
