import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';
import '../database/daos/cycle_dao.dart';
import '../database/daos/routine_dao.dart';
import '../database/daos/report_dao.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@Riverpod(keepAlive: true)
CycleDao cycleDao(Ref ref) {
  return ref.watch(appDatabaseProvider).cycleDao;
}

@Riverpod(keepAlive: true)
RoutineDao routineDao(Ref ref) {
  return ref.watch(appDatabaseProvider).routineDao;
}

@Riverpod(keepAlive: true)
ReportDao reportDao(Ref ref) {
  return ref.watch(appDatabaseProvider).reportDao;
}
