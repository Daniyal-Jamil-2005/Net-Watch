import 'package:http/http.dart' as http;
import 'router_client.dart';

class NetgearHandler extends RouterClient {
  NetgearHandler(super.ip, super.username, super.password);

  @override
  Future<bool> login() async {
    // SOAP API (ReadyDLNA)
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDeviceList() async {
    // soap/server_sa/XMLHandler.php
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
