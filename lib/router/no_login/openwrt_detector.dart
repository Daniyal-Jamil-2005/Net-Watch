import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'openwrt_detector.g.dart';

@riverpod
Future<String> openwrtDetector(OpenwrtDetectorRef ref, String ip) async {
  try {
     final responseLuci = await http.get(Uri.parse('http://$ip/cgi-bin/luci')).timeout(const Duration(seconds: 2));
     if (responseLuci.statusCode == 200 || responseLuci.statusCode == 403) {
         return "OpenWRT";
     }
  } catch (_) {}
  
  try {
     final responseInfo = await http.get(Uri.parse('http://$ip/Info.htm')).timeout(const Duration(seconds: 2));
     if (responseInfo.statusCode == 200 && responseInfo.body.contains("dd-wrt")) {
         return "DD-WRT";
     }
  } catch (_) {}

  return "None";
}
