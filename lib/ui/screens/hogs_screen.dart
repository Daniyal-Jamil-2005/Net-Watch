import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../intelligence/hogs_provider.dart';

class HogsScreen extends ConsumerWidget {
  const HogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hogsState = ref.watch(bandwidthHogsProvider);
    final suspectsCount = hogsState.valueOrNull?.length ?? 0;
    final isLagging = suspectsCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, color: isLagging ? Colors.orange : Colors.green),
            const SizedBox(width: 8),
            const Text('Bandwidth Hogs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? (isLagging ? [Colors.orange.shade900.withOpacity(0.3), Colors.deepOrange.shade900.withOpacity(0.3)] : [Colors.green.shade900.withOpacity(0.3), Colors.teal.shade900.withOpacity(0.3)])
                  : (isLagging ? [Colors.orange.shade50, Colors.deepOrange.shade50] : [Colors.green.shade50, Colors.teal.shade50]),
              ),
              border: Border.all(color: isLagging ? Colors.orange.shade400 : Colors.green.shade400, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(isLagging ? Icons.warning_amber_rounded : Icons.check_circle_outline, color: isLagging ? Colors.orange.shade700 : Colors.green.shade700, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isLagging ? 'Lag detected!' : 'Network stable', style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold,
                        color: isDark ? (isLagging ? Colors.orange.shade300 : Colors.green.shade300) : (isLagging ? Colors.orange.shade900 : Colors.green.shade900)
                      )),
                      const SizedBox(height: 4),
                      Text(isLagging ? 'Found $suspectsCount active hogs' : 'Analyzing devices...', style: TextStyle(
                        fontSize: 12,
                        color: isDark ? (isLagging ? Colors.orange.shade200 : Colors.green.shade200) : (isLagging ? Colors.orange.shade700 : Colors.green.shade700)
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLagging ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Live', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MOST LIKELY CAUSES', style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500
              )),
              Text('Updated 3s ago', style: TextStyle(
                fontSize: 11, fontFamily: 'monospace',
                color: Colors.grey.shade500
              )),
            ],
          ),
          const SizedBox(height: 16),

          ref.watch(bandwidthHogsProvider).when(
            data: (suspects) {
              if (suspects.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No active devices spiking traffic currently.")),
                );
              }
              
              return Column(
                children: [
                  for (int i = 0; i < suspects.length; i++)
                    _buildSuspectCard(suspects[i], i + 1, isDark, context)
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e,s) => const SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _buildSuspectCard(BandwidthSuspect suspect, int rank, bool isDark, BuildContext context) {
    bool isTop = rank == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTop ? Colors.orange.shade500 : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isTop ? 2 : 1,
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  gradient: isTop 
                    ? const LinearGradient(colors: [Colors.orange, Colors.deepOrange])
                    : const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('$rank', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: isTop 
                    ? const LinearGradient(colors: [Colors.orange, Colors.deepOrange])
                    : const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(suspect.device.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(suspect.device.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(suspect.behavior, style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold,
              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700
            )),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Est. Bandwidth', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
              Text('${suspect.confidence} Mbps', style: const TextStyle(fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (suspect.confidence / 100.0).clamp(0.05, 1.0),
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(suspect.detail, style: TextStyle(
                  fontSize: 11, fontFamily: 'monospace', fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500
                )),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network blocking requires root privileges or router integration.')));
                },
                style: TextButton.styleFrom(
                  backgroundColor: isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                ),
                child: const Text('Block Device', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
