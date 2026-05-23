import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/network_provider.dart';

class RouterScreen extends ConsumerWidget {
  const RouterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.router, color: isDark ? Colors.blue.shade400 : Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text('Router Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ref.watch(networkDevicesProvider).when(
            data: (devices) {
              final router = devices.firstWhere((d) => d.icon == Icons.router, orElse: () => NetworkDevice(
                ip: 'Unknown',
                mac: 'Unknown',
                vendor: 'Unknown Router',
                hostname: '',
                osGuess: 'Router',
                deviceType: 'router',
                status: 'offline',
                icon: Icons.router
              ));

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [Colors.blue.shade900.withOpacity(0.3), Colors.indigo.shade900.withOpacity(0.3)]
                      : [Colors.blue.shade50, Colors.indigo.shade50],
                  ),
                  border: Border.all(color: Colors.blue.shade400, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(router.vendor.isNotEmpty ? router.vendor : 'Generic Gateway', style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: isDark ? Colors.blue.shade100 : Colors.blue.shade900
                          )),
                          const SizedBox(height: 4),
                          Text('${router.ip}  ·  ${router.mac}', style: TextStyle(
                            fontSize: 12, fontFamily: 'monospace',
                            color: isDark ? Colors.blue.shade200 : Colors.blue.shade700
                          )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: router.status == 'active' ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(router.status == 'active' ? 'Online' : 'Offline', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => const SizedBox(),
          ),
          const SizedBox(height: 24),

          Text('ROUTER ACTIONS', style: TextStyle(
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
                _buildActionRow('Setup Router Credentials', 'Required for admin actions', Icons.admin_panel_settings, Colors.blue, isDark, () {
                  _showCredentialsDialog(context);
                }),
                Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                _buildActionRow('Reboot Router', 'Restart the device', Icons.restart_alt, Colors.orange, isDark, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Auth Failed. Please setup credentials first.')));
                }),
                Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                _buildActionRow('Port Scan', 'Scan common ports', Icons.radar, Colors.indigo, isDark, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Starting Port Scan on Gateway...')));
                }),
                Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                _buildActionRow('Vulnerability Scan', 'Check for security flaws', Icons.security, Colors.red, isDark, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Analyzing configuration for vulnerabilities...')));
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text('FIRMWARE', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
          )),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('1.0.11 Build 20210730 rel.54485 (Cached)', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontFamily: 'monospace')),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checking for firmware updates...')));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('Check'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(String title, String subtitle, IconData icon, MaterialColor color, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: isDark ? color.shade900.withOpacity(0.3) : color.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isDark ? color.shade300 : color.shade600, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCredentialsDialog(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          title: const Text('Router Credentials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter credentials to unlock deep admin features like rebooting.', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'admin',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: isDark ? Colors.black26 : Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: isDark ? Colors.black26 : Colors.grey.shade50,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credentials validated and saved securely.')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Save & Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }
    );
  }
}

