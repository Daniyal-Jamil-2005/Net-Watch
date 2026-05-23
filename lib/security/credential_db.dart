import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'credential_db.g.dart';

const _defaultCreds = [
  {"user": "admin", "pass": "admin"},
  {"user": "admin", "pass": "password"},
  {"user": "root", "pass": "root"},
  {"user": "admin", "pass": "1234"},
  {"user": "admin", "pass": ""},
];

@riverpod
Future<Map<String, String>?> checkDefaultCreds(CheckDefaultCredsRef ref, String ip) async {
   for (final cred in _defaultCreds) {
       final auth = base64Encode(utf8.encode('${cred["user"]}:${cred["pass"]}'));
       try {
           final response = await http.get(Uri.parse('http://$ip/'), headers: {
              'Authorization': 'Basic $auth'
           }).timeout(const Duration(milliseconds: 800));
           if (response.statusCode != 401 && response.statusCode < 500) {
               return cred; // Found working credentials
           }
       } catch (_) {}
   }
   return null; // Safe
}
