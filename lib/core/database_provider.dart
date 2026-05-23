import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'netwatch.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE ping_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          timestamp INTEGER,
          router_ping REAL,
          internet_ping REAL,
          dns_ping REAL
        )
      ''');
      
      await db.execute('''
        CREATE TABLE known_devices (
          mac TEXT PRIMARY KEY,
          custom_name TEXT,
          icon_type TEXT,
          is_blocked INTEGER DEFAULT 0,
          is_prioritized INTEGER DEFAULT 0
        )
      ''');
      
      await db.execute('''
        CREATE TABLE device_behavior (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          mac TEXT,
          timestamp INTEGER,
          response_ms REAL,
          throughput_mbps REAL
        )
      ''');
    },
  );
});
