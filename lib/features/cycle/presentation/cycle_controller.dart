import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';

part 'cycle_controller.g.dart';

class CycleState {
  final List<CycleEvent> recentEvents;
  final int? currentCycleDay; // e.g., 23
  final CycleEvent? currentPeriodStart;

  CycleState({
    this.recentEvents = const [],
    this.currentCycleDay,
    this.currentPeriodStart,
  });
}

@riverpod
class CycleController extends _$CycleController {
  @override
  Stream<CycleState> build() async* {
    final dao = ref.watch(cycleDaoProvider);
    
    await for (final events in dao.watchRecentEvents()) {
      int? cycleDay;
      CycleEvent? periodStart;

      if (events.isNotEmpty) {
        // Find the most recent period start event (or assume the latest event is part of the current cycle)
        // For simplicity, we calculate cycle day from the most recent event.
        // A more complex app would find the most recent 'Heavy' or 'Medium' flow that started a streak.
        periodStart = events.first;
        final now = DateTime.now();
        cycleDay = now.difference(periodStart.date).inDays + 1;
      }

      yield CycleState(
        recentEvents: events,
        currentCycleDay: cycleDay,
        currentPeriodStart: periodStart,
      );
    }
  }

  Future<void> logCycleEvent({
    required DateTime date,
    required String flowType,
    String? bloodColor,
    String clotSize = 'None',
    bool isFlooding = false,
    List<String> symptoms = const [],
    String? notes,
  }) async {
    final dao = ref.read(cycleDaoProvider);
    await dao.logCycleEvent(
      date: date,
      flowType: flowType,
      bloodColor: bloodColor,
      clotSize: clotSize,
      isFlooding: isFlooding,
      symptoms: symptoms.isEmpty ? null : symptoms.join(', '),
      notes: notes,
    );
  }
}
