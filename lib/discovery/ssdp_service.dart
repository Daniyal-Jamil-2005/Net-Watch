import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/native/native_channels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'ssdp_service.g.dart';

class SsdpDevice {
  final String ip;
  final String server;
  final String location;
  final String usn;

  SsdpDevice(this.ip, this.server, this.location, this.usn);
}

@riverpod
class SsdpScanner extends _$SsdpScanner {
  @override
  Future<List<SsdpDevice>> build() async => [];

  Future<void> scan() async {
    final native = ref.read(nativeChannelsProvider);
    state = const AsyncValue.loading();

    await native.acquireMulticastLock();
    
    final devices = <String, SsdpDevice>{};
    
    try {
      final RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.broadcastEnabled = true;
      socket.readEventsEnabled = true;
      
      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
            final Datagram? datagram = socket.receive();
            if (datagram != null) {
                final message = utf8.decode(datagram.data);
                final ip = datagram.address.address;
                
                final serverMatch = RegExp(r'Server:\s*(.*)', caseSensitive: false).firstMatch(message);
                final locMatch = RegExp(r'Location:\s*(.*)', caseSensitive: false).firstMatch(message);
                final usnMatch = RegExp(r'USN:\s*(.*)', caseSensitive: false).firstMatch(message);
                
                devices[ip] = SsdpDevice(
                   ip, 
                   (serverMatch?.group(1) ?? 'Unknown').trim(), 
                   (locMatch?.group(1) ?? '').trim(), 
                   (usnMatch?.group(1) ?? '').trim()
                );
            }
        }
      });
      
      final ssdpMessage = "M-SEARCH * HTTP/1.1\r\n"
          "HOST: 239.255.255.250:1900\r\n"
          "MAN: \"ssdp:discover\"\r\n"
          "MX: 3\r\n"
          "ST: ssdp:all\r\n\r\n";
          
      socket.send(utf8.encode(ssdpMessage), InternetAddress('239.255.255.250'), 1900);
      
      await Future.delayed(const Duration(seconds: 3));
      socket.close();
    } catch (e) {
      // ignore
    } finally {
      await native.releaseMulticastLock();
      state = AsyncValue.data(devices.values.toList());
    }
  }
}
