import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/date_utils.dart';
import '../../routines/domain/phase_state_machine.dart';

part 'today_controller.g.dart';

class TodayState {
  final Routine? activeRoutine;
  final RoutineLog? todayLog;
  final PhaseState? phaseState;
  final List<RoutineLog> missedRecentLogs; // Logs from past 72 hours that were missed

  TodayState({
    this.activeRoutine,
    this.todayLog,
    this.phaseState,
    this.missedRecentLogs = const [],
  });

  TodayState copyWith({
    Routine? activeRoutine,
    RoutineLog? todayLog,
    PhaseState? phaseState,
    List<RoutineLog>? missedRecentLogs,
  }) {
    return TodayState(
      activeRoutine: activeRoutine ?? this.activeRoutine,
      todayLog: todayLog ?? this.todayLog,
      phaseState: phaseState ?? this.phaseState,
      missedRecentLogs: missedRecentLogs ?? this.missedRecentLogs,
    );
  }
}

@riverpod
class TodayController extends _$TodayController {
  @override
  Stream<TodayState> build() async* {
    final dao = ref.watch(routineDaoProvider);
    final now = DateTime.now();

    await for (final routine in dao.watchActiveRoutine()) {
      if (routine == null) {
        yield TodayState();
        continue;
      }

      // Compute PhaseState if it's a cyclic routine
      PhaseState? phaseState;
      if (routine.regimenType == 'Cyclic_21_7') {
        phaseState = PhaseState.calculate(
          startDate: routine.startDate,
          targetDate: now,
          activeDays: routine.activeDays,
          breakDays: routine.breakDays,
        );
      } else {
        // For Daily, it's always active, no breaks
        phaseState = PhaseState(
          currentPhase: 1,
          dayInPhase: now.difference(routine.startDate).inDays + 1,
          totalPhaseDays: 999, // indefinite
          isBreakPeriod: false,
        );
      }

      // Get today's log
      final todayLogStream = dao.watchLogForDate(routine.id, now);
      
      // Calculate missed logs in the past 72 hours
      final threeDaysAgo = now.subtract(const Duration(days: 3));
      final recentLogs = await dao.getLogsInRange(routine.id, threeDaysAgo, now.subtract(const Duration(days: 1)));
      
      // Identify missing days or days marked as missed
      List<RoutineLog> missedRecent = [];
      for (int i = 1; i <= 3; i++) {
        final d = now.subtract(Duration(days: i));
        // We only care if they should have taken a pill that day.
        // If they were on a break, they don't miss anything.
        final pastPhase = PhaseState.calculate(
          startDate: routine.startDate,
          targetDate: d,
          activeDays: routine.activeDays,
          breakDays: routine.breakDays,
        );
        
        if (!pastPhase.isBreakPeriod) {
          final logForD = recentLogs.where((l) => AppDateUtils.isSameDay(l.scheduledDate, d)).firstOrNull;
          if (logForD == null || logForD.status == 'Missed') {
            missedRecent.add(RoutineLog(
              id: logForD?.id ?? 0,
              routineId: routine.id,
              scheduledDate: AppDateUtils.stripTime(d),
              status: 'Missed',
              completedAt: logForD?.completedAt,
            ));
          }
        }
      }

      await for (final todayLog in todayLogStream) {
        yield TodayState(
          activeRoutine: routine,
          todayLog: todayLog,
          phaseState: phaseState,
          missedRecentLogs: missedRecent,
        );
      }
    }
  }

  Future<void> markTaken(DateTime date) async {
    final routine = state.value?.activeRoutine;
    if (routine == null) return;
    
    await ref.read(routineDaoProvider).logIntake(
      routineId: routine.id,
      scheduledDate: date,
      status: 'Taken',
      completedAt: DateTime.now(),
    );
    // Note: Stream will auto-update state
  }

  Future<void> markSkipped(DateTime date) async {
    final routine = state.value?.activeRoutine;
    if (routine == null) return;
    
    await ref.read(routineDaoProvider).logIntake(
      routineId: routine.id,
      scheduledDate: date,
      status: 'Skipped',
    );
  }
}
