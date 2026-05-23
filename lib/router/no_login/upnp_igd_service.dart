import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'upnp_igd_service.g.dart';

@riverpod
class UpnpIgdScanner extends _$UpnpIgdScanner {
  @override
  Future<Map<String, String>> build() async => {};

  Future<Map<String, String>> scan(String controlUrl) async {
    state = const AsyncValue.loading();
    final results = <String, String>{};
    
    // Example SOAP for GetExternalIPAddress
    final soapBody = '''<?xml version="1.0"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <s:Body>
    <u:GetExternalIPAddress xmlns:u="urn:schemas-upnp-org:service:WANIPConnection:1">
    </u:GetExternalIPAddress>
  </s:Body>
</s:Envelope>''';

    try {
      final response = await http.post(
        Uri.parse(controlUrl),
        headers: {
          'Content-Type': 'text/xml; charset="utf-8"',
          'SOAPAction': '"urn:schemas-upnp-org:service:WANIPConnection:1#GetExternalIPAddress"'
        },
        body: soapBody,
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final ipMatch = RegExp(r'<NewExternalIPAddress>(.*?)</NewExternalIPAddress>').firstMatch(response.body);
        if (ipMatch != null) {
            results['WAN_IP'] = ipMatch.group(1) ?? "Unknown";
        }
      }
    } catch (_) {}
    
    state = AsyncValue.data(results);
    return results;
  }
}
