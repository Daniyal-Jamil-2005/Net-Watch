import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/native/native_channels.dart';

// ---------------------------------------------------------------------------
// Provider — real device model + IP (no codegen needed, plain FutureProvider)
// ---------------------------------------------------------------------------

final deviceInfoProvider = FutureProvider.autoDispose<Map<String, String>>((ref) async {
  final native = ref.read(nativeChannelsProvider);
  final raw = await native.getDeviceInfo();
  return {
    'model': raw['model']?.toString() ?? 'Unknown Device',
    'ip': raw['ip']?.toString() ?? '—',
  };
});

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _bgScanning = true;
  bool _notifications = true;
  bool _autoBlock = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final deviceAsync = ref.watch(deviceInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Device & Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── This Device ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.indigo]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      const Icon(Icons.smartphone, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: deviceAsync.when(
                    data: (info) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('This Device',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(info['model']!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600)),
                        const SizedBox(height: 2),
                        Text(info['ip']!,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: Colors.grey.shade500)),
                      ],
                    ),
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('This Device',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ),
                    error: (e, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('This Device',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Unable to load device info',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Preferences ───────────────────────────────────────────────
          Text('PREFERENCES',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color:
                      isDark ? Colors.grey.shade400 : Colors.grey.shade500)),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Background Scanning',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text(
                      'Periodically check the network for changes',
                      style: TextStyle(fontSize: 12)),
                  value: _bgScanning,
                  onChanged: (v) => setState(() => _bgScanning = v),
                  activeColor: Colors.blue,
                ),
                Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200),
                SwitchListTile(
                  title: const Text('Push Notifications',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text(
                      'Alert on new devices and network issues',
                      style: TextStyle(fontSize: 12)),
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                  activeColor: Colors.blue,
                ),
                Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200),
                SwitchListTile(
                  title: const Text('Auto-block Suspects',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text(
                      'Automatically block devices that cause extreme lag',
                      style: TextStyle(fontSize: 12)),
                  value: _autoBlock,
                  onChanged: (v) => setState(() => _autoBlock = v),
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── About ─────────────────────────────────────────────────────
          Text('ABOUT',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color:
                      isDark ? Colors.grey.shade400 : Colors.grey.shade500)),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ListTile(
                  title:
                      const Text('Version', style: TextStyle(fontSize: 14)),
                  trailing: Text('1.0.0 (Beta)',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 14)),
                ),
                Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200),
                ListTile(
                  title: const Text('Terms of Service',
                      style: TextStyle(fontSize: 14)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200),
                ListTile(
                  title: const Text('Privacy Policy',
                      style: TextStyle(fontSize: 14)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
