import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/date_utils.dart';
import '../../routines/domain/phase_state_machine.dart';

part 'today_controller.g.dart';

/// Per-routine computed state for a single medication on today's screen.
class RoutineCardState {
  final Routine routine;
  final RoutineLog? todayLog;
  final PhaseState phaseState;

  const RoutineCardState({
    required this.routine,
    required this.phaseState,
    this.todayLog,
  });
}

class TodayState {
  /// All active routines with their computed phase + today log.
  final List<RoutineCardState> routineCards;

  /// Missed logs from the past 72 h across ALL routines (for Catch-Up drawer).
  final List<RoutineLog> missedRecentLogs;

  // Legacy single-routine accessors kept for backward compat on today_screen.
  Routine? get activeRoutine => routineCards.isNotEmpty ? routineCards.first.routine : null;
  RoutineLog? get todayLog => routineCards.isNotEmpty ? routineCards.first.todayLog : null;
  PhaseState? get phaseState => routineCards.isNotEmpty ? routineCards.first.phaseState : null;

  const TodayState({
    this.routineCards = const [],
    this.missedRecentLogs = const [],
  });
}

@riverpod
class TodayController extends _$TodayController {
  @override
  Stream<TodayState> build() {
    final dao = ref.watch(routineDaoProvider);
    final now = DateTime.now();

    final controller = StreamController<TodayState>();
    StreamSubscription? routinesSub;
    StreamSubscription? logsSub;

    ref.onDispose(() {
      routinesSub?.cancel();
      logsSub?.cancel();
      controller.close();
    });

    // Watch all active routines
    routinesSub = dao.watchActiveRoutines().listen((routines) {
      if (routines.isEmpty) {
        logsSub?.cancel();
        controller.add(const TodayState());
        return;
      }

      // Filter out expired routines
      final validRoutines = routines.where((r) {
        if (r.endDate == null) return true;
        return !now.isAfter(r.endDate!.add(const Duration(days: 1)));
      }).toList();

      if (validRoutines.isEmpty) {
        logsSub?.cancel();
        controller.add(const TodayState());
        return;
      }

      final activeIds = validRoutines.map((r) => r.id).toList();
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      logsSub?.cancel();
      logsSub = dao.watchRecentLogsForRoutines(activeIds, threeDaysAgo, now).listen((allRecentLogs) {
        final List<RoutineCardState> cards = [];
        final List<RoutineLog> allMissed = [];

        for (final routine in validRoutines) {
          PhaseState phaseState;
          if (routine.regimenType == 'Cyclic_21_7') {
            phaseState = PhaseState.calculate(
              startDate: routine.startDate,
              targetDate: now,
              activeDays: routine.activeDays,
              breakDays: routine.breakDays,
            );
          } else {
            phaseState = PhaseState(
              currentPhase: 1,
              dayInPhase: now.difference(routine.startDate).inDays + 1,
              totalPhaseDays: null,
              isBreakPeriod: false,
            );
          }

          final routineLogs = allRecentLogs.where((l) => l.routineId == routine.id).toList();

          // Calculate missed logs for past 3 days (excluding today)
          for (int i = 1; i <= 3; i++) {
            final d = now.subtract(Duration(days: i));
            final pastPhase = PhaseState.calculate(
              startDate: routine.startDate,
              targetDate: d,
              activeDays: routine.activeDays,
              breakDays: routine.breakDays,
            );
            if (!pastPhase.isBreakPeriod) {
              final logForD = routineLogs.where((l) => AppDateUtils.isSameDay(l.scheduledDate, d)).firstOrNull;
              if (logForD == null || logForD.status == 'Missed') {
                allMissed.add(RoutineLog(
                  id: logForD?.id ?? 0,
                  routineId: routine.id,
                  scheduledDate: AppDateUtils.stripTime(d),
                  status: 'Missed',
                  completedAt: logForD?.completedAt,
                ));
              }
            }
          }

          final todayLog = routineLogs.where((l) => AppDateUtils.isSameDay(l.scheduledDate, now)).firstOrNull;
          cards.add(RoutineCardState(routine: routine, phaseState: phaseState, todayLog: todayLog));
        }

        controller.add(TodayState(routineCards: cards, missedRecentLogs: allMissed));
      });
    });

    return controller.stream;
  }

  Future<void> markTaken(DateTime date, {DateTime? completedAt, int? routineId}) async {
    final id = routineId ?? state.value?.activeRoutine?.id;
    if (id == null) return;
    await ref.read(routineDaoProvider).logIntake(
          routineId: id,
          scheduledDate: date,
          status: 'Taken',
          completedAt: completedAt ?? DateTime.now(),
        );
  }

  Future<void> markSkipped(DateTime date, {int? routineId}) async {
    final id = routineId ?? state.value?.activeRoutine?.id;
    if (id == null) return;
    await ref.read(routineDaoProvider).logIntake(
          routineId: id,
          scheduledDate: date,
          status: 'Skipped',
        );
  }

  Future<void> deleteRoutine(int routineId) async {
    await ref.read(routineDaoProvider).deleteRoutine(routineId);
  }
}
