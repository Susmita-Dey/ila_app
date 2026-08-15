import 'package:drift/drift.dart';

class CycleEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get flowType => text()(); // Spotting, Light, Medium, Heavy
  TextColumn get bloodColor => text().nullable()(); // BrightRed, DarkBrown, Pink
  TextColumn get clotSize => text().withDefault(const Constant('None'))(); // None, Small, Large
  BoolColumn get isFlooding => boolean().withDefault(const Constant(false))(); // Soaking < 2 hrs
  TextColumn get symptoms => text().nullable()(); // Comma separated list
  TextColumn get notes => text().nullable()();
  BoolColumn get isTrueCycleStart => boolean().withDefault(const Constant(true))();
  TextColumn get painReliefStatus => text().nullable()(); // None, Partial, Complete
}

class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // e.g. "Birth Control", "Inositol"
  TextColumn get regimenType => text()(); // e.g. "Cyclic_21_7", "Daily"
  IntColumn get activeDays => integer().withDefault(const Constant(21))();
  IntColumn get breakDays => integer().withDefault(const Constant(7))();
  DateTimeColumn get startDate => dateTime()();
  TextColumn get reminderTime => text()(); // e.g. "20:00"
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class RoutineLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  DateTimeColumn get scheduledDate => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get status => text()(); // Taken, Missed, Skipped
}

class TreatmentInterventions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()(); // e.g., "Started Metformin + Inositol"
  DateTimeColumn get startDate => dateTime()();
  TextColumn get notes => text().nullable()();
}
