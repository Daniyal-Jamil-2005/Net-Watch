import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'tp_link_handler.dart';
import 'huawei_handler.dart';
import 'zte_handler.dart';
import 'dlink_handler.dart';
import 'netgear_handler.dart';
import 'openwrt_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'router_client.g.dart';

abstract class RouterClient {
  final String ip;
  final String username;
  final String password;

  RouterClient(this.ip, this.username, this.password);

  Future<bool> login();
  Future<Map<String, dynamic>> fetchDeviceList();
  Future<Map<String, int>> fetchBandwidth();
  Future<bool> blockDevice(String macAddress);
}

@riverpod
RouterClient? activeRouterClient(ActiveRouterClientRef ref, String brand, String ip, String user, String pass) {
  switch (brand) {
    case 'TP-Link': return TpLinkHandler(ip, user, pass);
    case 'Huawei': return HuaweiHandler(ip, user, pass);
    case 'ZTE': return ZteHandler(ip, user, pass);
    case 'D-Link': return DLinkHandler(ip, user, pass);
    case 'Netgear': return NetgearHandler(ip, user, pass);
    case 'OpenWRT': return OpenwrtHandler(ip, user, pass);
    default: return null;
  }
}
