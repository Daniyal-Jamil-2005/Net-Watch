import 'dart:convert';
import 'package:http/http.dart' as http;
import 'router_client.dart';

class DLinkHandler extends RouterClient {
  DLinkHandler(super.ip, super.username, super.password);

  @override
  Future<bool> login() async {
    // Basic auth header to getcfg.php
    return false;
  }

  @override
  Future<Map<String, dynamic>> fetchDeviceList() async {
    // getclientinfo
    return {};
  }

  @override
  Future<Map<String, int>> fetchBandwidth() async {
    return {"rx": 0, "tx": 0};
  }

  @override
  Future<bool> blockDevice(String macAddress) async {
    // setclientfilter.php POST
    return false;
  }
}
