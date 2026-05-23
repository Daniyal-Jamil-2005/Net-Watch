import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'correlation_engine.g.dart';

class Incident {
  final DateTime time;
  final String description;
  final String probableCause;

  Incident(this.time, this.description, this.probableCause);
}

@riverpod
List<Incident> networkIncidents(NetworkIncidentsRef ref) {
  // Stub implementation aggregating lag spikes and device activity
  return [
    Incident(DateTime.now(), "Lag spike detected (120ms jitter)", "Smart TV became active on same subnet")
  ];
}
