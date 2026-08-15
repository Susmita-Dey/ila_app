// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $CycleEventsTable get cycleEvents => attachedDatabase.cycleEvents;
  $RoutinesTable get routines => attachedDatabase.routines;
  $RoutineLogsTable get routineLogs => attachedDatabase.routineLogs;
  $TreatmentInterventionsTable get treatmentInterventions =>
      attachedDatabase.treatmentInterventions;
  ReportDaoManager get managers => ReportDaoManager(this);
}

class ReportDaoManager {
  final _$ReportDaoMixin _db;
  ReportDaoManager(this._db);
  $$CycleEventsTableTableManager get cycleEvents =>
      $$CycleEventsTableTableManager(_db.attachedDatabase, _db.cycleEvents);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db.attachedDatabase, _db.routines);
  $$RoutineLogsTableTableManager get routineLogs =>
      $$RoutineLogsTableTableManager(_db.attachedDatabase, _db.routineLogs);
  $$TreatmentInterventionsTableTableManager get treatmentInterventions =>
      $$TreatmentInterventionsTableTableManager(
        _db.attachedDatabase,
        _db.treatmentInterventions,
      );
}
