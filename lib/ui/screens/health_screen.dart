import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../intelligence/ping_engine.dart';
import '../../security/vulnerability_alerts.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Health', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [Colors.green.shade900.withOpacity(0.3), Colors.teal.shade900.withOpacity(0.3)]
                  : [Colors.green.shade50, Colors.teal.shade50],
              ),
              border: Border(left: BorderSide(color: Colors.green.shade500, width: 4)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Network Healthy', style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold,
                        color: isDark ? Colors.green.shade100 : Colors.green.shade900
                      )),
                      const SizedBox(height: 8),
                      Text('Router and internet connection are performing well', style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.green.shade300 : Colors.green.shade700
                      )),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: Colors.green.shade500, size: 36),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          ref.watch(pingEngineProvider).when(
            data: (stats) {
              final routerPing = stats['192.168.0.1']?.latency.toStringAsFixed(0) ?? '--';
              final internetPing = stats['8.8.8.8']?.latency.toStringAsFixed(0) ?? '--';
              final packetLoss = stats['8.8.8.8']?.packetLoss.toStringAsFixed(0) ?? '0';
              
              return Row(
                children: [
                  Expanded(child: _buildStatCard('${routerPing}ms', 'ROUTER PING', Icons.router, isDark, context)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('${internetPing}ms', 'INTERNET PING', Icons.public, isDark, context)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('$packetLoss%', 'PACKET LOSS', Icons.pie_chart_outline, isDark, context)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 16),

          // Vulnerability Alerts Section
          ref.watch(networkVulnerabilitiesProvider).when(
            data: (alerts) {
              if (alerts.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border.all(color: isDark ? Colors.green.shade900.withOpacity(0.5) : Colors.green.shade100),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.green.shade900.withOpacity(0.3) : Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shield_outlined, color: Colors.green.shade500, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Secure', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                            const SizedBox(height: 4),
                            Text('No major vulnerabilities detected on your network.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check, color: Colors.green),
                    ],
                  ),
                );
              }
              
              final String summaries = alerts.map((a) => a.title).join(' & ');
              
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border.all(color: isDark ? Colors.red.shade900.withOpacity(0.5) : Colors.red.shade100),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${alerts.length} Vulnerabilit${alerts.length == 1 ? 'y' : 'ies'} found', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                          const SizedBox(height: 4),
                          Text(summaries, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error loading vulnerabilities: $err', style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 24),

          Text('CONNECTION BREAKDOWN', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
          )),
          const SizedBox(height: 16),
          
          ref.watch(pingEngineProvider).when(
            data: (stats) {
              final jitter = stats['8.8.8.8']?.jitter.toStringAsFixed(1) ?? '--';
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildMetricRow('Jitter', '${jitter}ms', isDark),
                    Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    _buildMetricRow('DNS resolution', '15ms (Est.)', isDark),
                    Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    _buildMetricRow('Avg ping', '${stats['8.8.8.8']?.latency.toStringAsFixed(0) ?? '--'}ms', isDark),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (e,s) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, bool isDark, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 14, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}
