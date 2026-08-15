import 'package:drift/drift.dart';
import '../tables/schema_tables.dart';
import '../app_database.dart';
import '../../utils/date_utils.dart';

part 'cycle_dao.g.dart';

@DriftAccessor(tables: [CycleEvents])
class CycleDao extends DatabaseAccessor<AppDatabase> with _$CycleDaoMixin {
  CycleDao(AppDatabase db) : super(db);

  /// Get recent cycle events
  Stream<List<CycleEvent>> watchRecentEvents({int limit = 100}) {
    return (select(cycleEvents)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  /// Get all cycle events for calculations
  Future<List<CycleEvent>> getAllEvents() {
    return (select(cycleEvents)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .get();
  }

  /// Insert or update a cycle event
  Future<void> logCycleEvent({
    required DateTime date,
    required String flowType,
    String? bloodColor,
    String clotSize = 'None',
    bool isFlooding = false,
    bool isTrueCycleStart = true,
    String? painReliefStatus,
    String? symptoms,
    String? notes,
  }) async {
    final normalizedDate = AppDateUtils.stripTime(date);
    final companion = CycleEventsCompanion.insert(
      date: normalizedDate,
      flowType: flowType,
      bloodColor: Value(bloodColor),
      clotSize: Value(clotSize),
      isFlooding: Value(isFlooding),
      isTrueCycleStart: Value(isTrueCycleStart),
      painReliefStatus: Value(painReliefStatus),
      symptoms: Value(symptoms),
      notes: Value(notes),
    );
    
    // Check if an event exists for this date
    final existing = await (select(cycleEvents)
          ..where((t) => t.date.equals(normalizedDate))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await update(cycleEvents).replace(
        companion.copyWith(id: Value(existing.id)),
      );
    } else {
      await into(cycleEvents).insert(companion);
    }
  }

  /// Delete a cycle event
  Future<void> deleteCycleEvent(int id) {
    return (delete(cycleEvents)..where((t) => t.id.equals(id))).go();
  }
}
