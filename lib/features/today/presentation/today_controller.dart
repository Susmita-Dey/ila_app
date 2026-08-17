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
    final Map<int, StreamSubscription> logSubs = {};

    ref.onDispose(() {
      routinesSub?.cancel();
      for (final sub in logSubs.values) {
        sub.cancel();
      }
      controller.close();
    });

    // Watch all active routines
    routinesSub = dao.watchActiveRoutines().listen((routines) async {
      // Cancel stale log subscriptions for removed routines
      final activeIds = routines.map((r) => r.id).toSet();
      for (final id in logSubs.keys.toList()) {
        if (!activeIds.contains(id)) {
          await logSubs[id]?.cancel();
          logSubs.remove(id);
        }
      }

      if (routines.isEmpty) {
        controller.add(const TodayState());
        return;
      }

      // Filter out expired routines
      final validRoutines = routines.where((r) {
        if (r.endDate == null) return true;
        return !now.isAfter(r.endDate!.add(const Duration(days: 1)));
      }).toList();

      if (validRoutines.isEmpty) {
        controller.add(const TodayState());
        return;
      }

      // Compute phase + missed logs per routine
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

        // Missed logs past 72 h
        final threeDaysAgo = now.subtract(const Duration(days: 3));
        final recentLogs =
            await dao.getLogsInRange(routine.id, threeDaysAgo, now.subtract(const Duration(days: 1)));

        for (int i = 1; i <= 3; i++) {
          final d = now.subtract(Duration(days: i));
          final pastPhase = PhaseState.calculate(
            startDate: routine.startDate,
            targetDate: d,
            activeDays: routine.activeDays,
            breakDays: routine.breakDays,
          );
          if (!pastPhase.isBreakPeriod) {
            final logForD =
                recentLogs.where((l) => AppDateUtils.isSameDay(l.scheduledDate, d)).firstOrNull;
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

        // Subscribe to today's log for this routine
        logSubs[routine.id]?.cancel();
        logSubs[routine.id] = dao.watchLogForDate(routine.id, now).listen((todayLog) {
          // Rebuild card list with updated log for this routine
          final updatedCards = validRoutines.map((r) {
            if (r.id == routine.id) {
              return RoutineCardState(routine: r, phaseState: phaseState, todayLog: todayLog);
            }
            final existing = cards.where((c) => c.routine.id == r.id).firstOrNull;
            return existing ??
                RoutineCardState(routine: r, phaseState: phaseState, todayLog: null);
          }).toList();
          controller.add(TodayState(routineCards: updatedCards, missedRecentLogs: allMissed));
        });

        cards.add(RoutineCardState(routine: routine, phaseState: phaseState));
      }

      controller.add(TodayState(routineCards: cards, missedRecentLogs: allMissed));
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
