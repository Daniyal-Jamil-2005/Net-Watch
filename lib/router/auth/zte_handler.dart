import 'package:http/http.dart' as http;
import 'router_client.dart';

class ZteHandler extends RouterClient {
  ZteHandler(super.ip, super.username, super.password);

  @override
  Future<bool> login() async {
    // Form + cookie session to /
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDeviceList() async {
    // /goform/GetConnectedDevice
    return {};
  }

  @override
  Future<Map<String, int>> fetchBandwidth() async {
    // /goform/getStat
    return {"rx": 0, "tx": 0};
  }

  @override
  Future<bool> blockDevice(String macAddress) async {
    // /goform/SetMacFilter POST
    return false;
  }
}
