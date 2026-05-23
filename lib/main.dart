import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ui/theme.dart';
import 'ui/app_layout.dart';
import 'discovery/mdns_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await [
    Permission.locationWhenInUse,
    Permission.location,
    Permission.notification,
    Permission.nearbyWifiDevices,
  ].request();

  runApp(
    const ProviderScope(
      child: NetwatchApp(),
    ),
  );
}

class NetwatchApp extends StatelessWidget {
  const NetwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netwatch',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const _AppBootstrap(),
    );
  }
}

class _AppBootstrap extends ConsumerStatefulWidget {
  const _AppBootstrap();

  @override
  ConsumerState<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends ConsumerState<_AppBootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mdnsScannerProvider.notifier).scan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppLayout();
  }
}
