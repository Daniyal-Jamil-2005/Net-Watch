import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_client.dart';

class TpLinkHandler extends RouterClient {
  String? _cookie;

  TpLinkHandler(super.ip, super.username, super.password);

  @override
  Future<bool> login() async {
    try {
       final auth = base64Encode(utf8.encode('$username:$password'));
       final response = await http.get(Uri.parse('http://$ip/userRpm/LoginRpm.htm?Save=Save'), headers: {
          'Authorization': 'Basic $auth'
       });
       if (response.statusCode == 200 || response.statusCode == 401) {
           _cookie = response.headers['set-cookie'];
           return true; 
       }
    } catch (_) {}
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDeviceList() async {
    // Poll typical AssignedIpAddrListRpm.htm
    return {"status": "mocked", "devices": []};
  }

  @override
  Future<Map<String, int>> fetchBandwidth() async {
    return {"rx": 0, "tx": 0};
  }

  @override
  Future<bool> blockDevice(String macAddress) async {
    // POST to WlanMacFilterRpm.htm
    return false;
  }
}
