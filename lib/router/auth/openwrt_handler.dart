import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_client.dart';

class OpenwrtHandler extends RouterClient {
  String? _ubusToken;

  OpenwrtHandler(super.ip, super.username, super.password);

  @override
  Future<bool> login() async {
    try {
      final res = await http.post(
        Uri.parse('http://$ip/ubus'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "jsonrpc": "2.0",
          "id": 1,
          "method": "call",
          "params": ["00000000000000000000000000000000", "session", "login", {"username": username, "password": password}]
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _ubusToken = data['result']?[1]?['ubus_rpc_session'];
        return _ubusToken != null;
      }
    } catch (_) {}
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDeviceList() async {
    if (_ubusToken == null) return {};
    // network.wireless / iwinfo calls
    return {};
  }

  @override
  Future<Map<String, int>> fetchBandwidth() async {
    return {"rx": 0, "tx": 0};
  }

  @override
  Future<bool> blockDevice(String macAddress) async {
    return false;
  }
}
