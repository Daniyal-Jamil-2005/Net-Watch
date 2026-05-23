import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/network_provider.dart';
import '../../discovery/mdns_service.dart';
import '../../discovery/arp_service.dart';
import '../../intelligence/ping_engine.dart';
import 'device_detail_screen.dart';
import 'settings_screen.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  const OverviewScreen({super.key});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  int _lastScan = 0;
  bool _scanning = false;
  Timer? _timer;
  bool _showNewDeviceBanner = false; // only true when a REAL new device detected
  String? _newDeviceName;
  final Set<String> _seenIps = {};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_scanning) setState(() => _lastScan++);
    });
    // Listen for new devices appearing after the first scan baseline is set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(networkDevicesProvider, (prev, next) {
        final devices = next.valueOrNull;
        if (devices == null) return;
        if (_seenIps.isEmpty) {
          // First load: seed the baseline, show nothing
          _seenIps.addAll(devices.map((d) => d.ip));
          return;
        }
        for (final d in devices) {
          if (!_seenIps.contains(d.ip)) {
            _seenIps.add(d.ip);
            if (mounted) {
              setState(() {
                _newDeviceName = d.displayName;
                _showNewDeviceBanner = true;
              });
            }
            break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleRescan() {
    setState(() {
      _scanning = true;
      _lastScan = 0;
    });
    
    // Invalidate cached results to force a fresh discovery
    ref.invalidate(networkDevicesProvider);
    ref.read(mdnsScannerProvider.notifier).scan();
    
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) setState(() => _scanning = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final wifiSsidState = ref.watch(wifiSsidProvider);
    final devicesState = ref.watch(networkDevicesProvider);
    final pingState = ref.watch(pingEngineProvider);

    final deviceCount = devicesState.valueOrNull?.length ?? 0;
    final avgPing = pingState.valueOrNull?['8.8.8.8']?.latency.toStringAsFixed(0) ?? '--';
    final packetLoss = pingState.valueOrNull?['8.8.8.8']?.packetLoss.toStringAsFixed(0) ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('NetWatch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                  : [const Color(0xFFEFF6FF), const Color(0xFFEEF2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFDBEAFE)),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.blue.shade900 : Colors.blue.shade500).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Home Network', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: isDark ? Colors.blue.shade100 : Colors.blue.shade900,
                    )),
                    Text(wifiSsidState.valueOrNull ?? 'Searching...', style: TextStyle(
                      fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.w500,
                      color: isDark ? Colors.blue.shade400 : Colors.blue.shade600,
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatBadge('$deviceCount devices', isDark),
                    const SizedBox(width: 8),
                    _buildStatBadge('${avgPing}ms ping', isDark),
                    const SizedBox(width: 8),
                    _buildStatBadge('$packetLoss% loss', isDark),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: isDark ? Colors.blue.shade700 : Colors.blue.shade300, height: 1),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _handleRescan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last scanned $_lastScan seconds ago · Tap to rescan', style: TextStyle(
                        fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600
                      )),
                      if (_scanning)
                        const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressColorIndicator()
                        )
                      else
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Total Bandwidth Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.shade900.withOpacity(0.1) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.blue.shade900 : Colors.blue.shade200, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.speed, color: isDark ? Colors.blue.shade200 : Colors.blue.shade700, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Device Traffic', style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800
                        )),
                        const SizedBox(height: 2),
                         Text('Total live bandwidth', style: TextStyle(
                          fontSize: 11, color: isDark ? Colors.grey.shade500 : Colors.grey.shade600
                        )),
                      ],
                    ),
                  ],
                ),
                ref.watch(networkSpeedProvider).when(
                  data: (mbps) => Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(mbps.toStringAsFixed(1), style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black
                      )),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('Mbps', style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade600
                        )),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                  error: (_, __) => const Text('---', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // New-device banner — only shown when a real new device joins after
          // the first scan. Seeded from the first successful device load.
          if (_showNewDeviceBanner && _newDeviceName != null)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.3), blurRadius: 12)
                  ]),
              child: Row(
                children: [
                  const Icon(Icons.wifi, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                        'New device joined · $_newDeviceName',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  InkWell(
                    onTap: () =>
                        setState(() => _showNewDeviceBanner = false),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                  )
                ],
              ),
            ),

          Text('DEVICES ON NETWORK', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
          )),
          const SizedBox(height: 16),

          ref.watch(networkDevicesProvider).when(
            data: (devices) => Column(
              children: devices.map((d) => _buildDeviceCard(d, isDark)).toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8),
        border: Border.all(color: isDark ? Colors.blue.shade900 : Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(
        fontSize: 11, fontWeight: FontWeight.bold,
        color: isDark ? Colors.blue.shade100 : Colors.blue.shade900
      )),
    );
  }

  Widget _buildDeviceCard(NetworkDevice device, bool isDark) {
    final status = device.status;
    Color iconBgColor;
    Color statusColor;

    if (device.isSelf) {
      iconBgColor = Colors.green.shade700;
      statusColor = Colors.green;
    } else if (device.deviceType == 'router') {
      iconBgColor = Colors.indigo;
      statusColor = Colors.green;
    } else if (status == 'idle') {
      iconBgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
      statusColor = Colors.grey;
    } else {
      iconBgColor = Colors.blue;
      statusColor = Colors.green;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DeviceDetailScreen(device: device)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ]
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(device.icon, color: status == 'idle' ? Colors.grey : Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(device.displayName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                    device.ip,
                    style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (device.isSelf)
                        _buildTag('This Device', Colors.green, isDark),
                      if (device.deviceType == 'router')
                        _buildTag('Gateway', Colors.indigo, isDark),
                      if (device.osGuess == 'Windows')
                        _buildTag('Windows', Colors.blue, isDark),
                      if (device.osGuess == 'Router' && device.deviceType != 'router')
                        _buildTag('Network Equipment', Colors.orange, isDark),
                      if (device.ssdpServer.isNotEmpty)
                        _buildTag(device.ssdpServer.split('/').first, Colors.purple, isDark),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, MaterialColor color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? color.shade900.withOpacity(0.5) : color.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(
        fontSize: 10, fontWeight: FontWeight.bold,
        color: isDark ? color.shade200 : color.shade700,
      )),
    );
  }
}

class CircularProgressColorIndicator extends StatelessWidget {
  const CircularProgressColorIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.blue));
  }
}
