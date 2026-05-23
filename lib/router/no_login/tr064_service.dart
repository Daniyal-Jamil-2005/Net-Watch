import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'tr064_service.g.dart';

@riverpod
class Tr064Scanner extends _$Tr064Scanner {
  @override
  Future<bool> build() async => false;

  Future<bool> checkTr064(String ip) async {
    state = const AsyncValue.loading();
    try {
      final url = Uri.parse('http://$ip:49000/tr64desc.xml');
      final response = await http.get(url).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200 && response.body.contains("WLANConfiguration")) {
        state = const AsyncValue.data(true);
        return true;
      }
    } catch (_) {}
    
    state = const AsyncValue.data(false);
    return false;
  }
}
