import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/network_provider.dart';
import '../../security/wake_on_lan.dart';

class DeviceDetailScreen extends ConsumerWidget {
  final NetworkDevice device;

  const DeviceDetailScreen({
    super.key,
    required this.device,
  });

  void _showActionToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(device.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {})
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Device Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                    ]
                  ),
                  child: Icon(device.icon, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (device.status == 'active' ? Colors.green : Colors.orange).withOpacity(0.1),
                    border: Border.all(color: device.status == 'active' ? Colors.green.shade200 : Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: device.status == 'active' ? Colors.green : Colors.orange, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(device.status == 'active' ? 'Online' : 'Offline', style: TextStyle(color: device.status == 'active' ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Network Info
          Text('NETWORK INFO', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
          )),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoRow('IP Address', device.ip, true, isDark),
                Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                _buildInfoRow('MAC Address', device.mac, true, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Identification
          Text('IDENTIFICATION', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
          )),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoRow('Vendor', device.vendor.isNotEmpty ? device.vendor : 'Unknown', false, isDark),
                Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                _buildInfoRow('Operating System', device.displayOs.isNotEmpty ? device.displayOs : 'Unknown', false, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          Text('ACTIONS', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
          )),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(child: _buildActionButton('Ping', Icons.radar, Colors.blue, isDark, () {
                _showActionToast(context, 'Ping sent to ${device.ip}');
              })),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton('Block', Icons.block, Colors.red, isDark, () {
                _showActionToast(context, 'Network blocking requires root privileges');
              })),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildActionButton('Wake', Icons.power_settings_new, Colors.green, isDark, () {
                ref.read(wakeOnLanProvider.notifier).wake(device.mac);
                _showActionToast(context, 'Magic Packet sent to ${device.mac}');
              })),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton('Scan Ports', Icons.search, Colors.purple, isDark, () {
                _showActionToast(context, 'Port scanning started... (Check router logs)');
              })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isMono, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
          Text(value, style: TextStyle(
            fontSize: 14, 
            fontFamily: isMono ? 'monospace' : null, 
            fontWeight: FontWeight.w600, 
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800
          )),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, MaterialColor color, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? color.shade900.withOpacity(0.2) : color.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? color.shade900.withOpacity(0.5) : color.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color.shade500, size: 24),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
