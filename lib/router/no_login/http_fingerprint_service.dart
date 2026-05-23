import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'http_fingerprint_service.g.dart';

class RouterFingerprint {
  final String serverHeader;
  final String authRealm;
  final String htmlTitle;
  final String detectedBrand;

  RouterFingerprint(this.serverHeader, this.authRealm, this.htmlTitle, this.detectedBrand);
}

@riverpod
class HttpFingerprintScanner extends _$HttpFingerprintScanner {
  @override
  Future<RouterFingerprint?> build() async => null;

  Future<RouterFingerprint?> scan(String ip) async {
    state = const AsyncValue.loading();
    try {
      final url = Uri.parse('http://$ip/');
      final response = await http.get(url).timeout(const Duration(seconds: 3));
      
      final server = response.headers['server'] ?? '';
      final realm = response.headers['www-authenticate'] ?? '';
      
      final titleMatch = RegExp(r'<title>(.*?)</title>', caseSensitive: false).firstMatch(response.body);
      final title = titleMatch?.group(1) ?? '';
      
      String brand = 'Unknown';
      if (server.toLowerCase().contains('tp-link') || title.toLowerCase().contains('tp-link')) {
         brand = 'TP-Link';
      } else if (server.toLowerCase().contains('huawei') || title.toLowerCase().contains('huawei')) {
         brand = 'Huawei';
      } else if (title.toLowerCase().contains('zte') || realm.toLowerCase().contains('zte')) {
         brand = 'ZTE';
      } else if (title.toLowerCase().contains('d-link') || server.toLowerCase().contains('d-link')) {
         brand = 'D-Link';
      }

      final fp = RouterFingerprint(server, realm, title, brand);
      state = AsyncValue.data(fp);
      return fp;

    } catch (_) {}
    
    state = const AsyncValue.data(null);
    return null;
  }
}
