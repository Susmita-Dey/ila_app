import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/schema_tables.dart';
import 'daos/cycle_dao.dart';
import 'daos/routine_dao.dart';
import 'daos/report_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [CycleEvents, Routines, RoutineLogs, TreatmentInterventions],
  daos: [CycleDao, RoutineDao, ReportDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Used for testing with in-memory database
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(cycleEvents, cycleEvents.isTrueCycleStart);
            await m.addColumn(cycleEvents, cycleEvents.painReliefStatus);
            await m.createTable(treatmentInterventions);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'Ila_health.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

