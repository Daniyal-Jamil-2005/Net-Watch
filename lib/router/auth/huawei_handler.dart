import 'package:http/http.dart' as http;
import 'router_client.dart';

class HuaweiHandler extends RouterClient {
  HuaweiHandler(super.ip, super.username, super.password);

  @override
  Future<bool> login() async {
    // Huawei usually requires specific CSRF/Token logic scraping /html/index.html
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDeviceList() async {
    // /api/wlan/host-list
    return {};
  }

  @override
  Future<Map<String, int>> fetchBandwidth() async {
    return {"rx": 0, "tx": 0};
  }

  @override
  Future<bool> blockDevice(String macAddress) async {
    // /api/security/mac-filter
    return false;
  }
}
