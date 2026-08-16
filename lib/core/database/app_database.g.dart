// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CycleEventsTable extends CycleEvents
    with TableInfo<$CycleEventsTable, CycleEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CycleEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _flowTypeMeta =
      const VerificationMeta('flowType');
  @override
  late final GeneratedColumn<String> flowType = GeneratedColumn<String>(
      'flow_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bloodColorMeta =
      const VerificationMeta('bloodColor');
  @override
  late final GeneratedColumn<String> bloodColor = GeneratedColumn<String>(
      'blood_color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clotSizeMeta =
      const VerificationMeta('clotSize');
  @override
  late final GeneratedColumn<String> clotSize = GeneratedColumn<String>(
      'clot_size', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('None'));
  static const VerificationMeta _isFloodingMeta =
      const VerificationMeta('isFlooding');
  @override
  late final GeneratedColumn<bool> isFlooding = GeneratedColumn<bool>(
      'is_flooding', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_flooding" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _symptomsMeta =
      const VerificationMeta('symptoms');
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
      'symptoms', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isTrueCycleStartMeta =
      const VerificationMeta('isTrueCycleStart');
  @override
  late final GeneratedColumn<bool> isTrueCycleStart = GeneratedColumn<bool>(
      'is_true_cycle_start', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_true_cycle_start" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _painReliefStatusMeta =
      const VerificationMeta('painReliefStatus');
  @override
  late final GeneratedColumn<String> painReliefStatus = GeneratedColumn<String>(
      'pain_relief_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        flowType,
        bloodColor,
        clotSize,
        isFlooding,
        symptoms,
        notes,
        isTrueCycleStart,
        painReliefStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_events';
  @override
  VerificationContext validateIntegrity(Insertable<CycleEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('flow_type')) {
      context.handle(_flowTypeMeta,
          flowType.isAcceptableOrUnknown(data['flow_type']!, _flowTypeMeta));
    } else if (isInserting) {
      context.missing(_flowTypeMeta);
    }
    if (data.containsKey('blood_color')) {
      context.handle(
          _bloodColorMeta,
          bloodColor.isAcceptableOrUnknown(
              data['blood_color']!, _bloodColorMeta));
    }
    if (data.containsKey('clot_size')) {
      context.handle(_clotSizeMeta,
          clotSize.isAcceptableOrUnknown(data['clot_size']!, _clotSizeMeta));
    }
    if (data.containsKey('is_flooding')) {
      context.handle(
          _isFloodingMeta,
          isFlooding.isAcceptableOrUnknown(
              data['is_flooding']!, _isFloodingMeta));
    }
    if (data.containsKey('symptoms')) {
      context.handle(_symptomsMeta,
          symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_true_cycle_start')) {
      context.handle(
          _isTrueCycleStartMeta,
          isTrueCycleStart.isAcceptableOrUnknown(
              data['is_true_cycle_start']!, _isTrueCycleStartMeta));
    }
    if (data.containsKey('pain_relief_status')) {
      context.handle(
          _painReliefStatusMeta,
          painReliefStatus.isAcceptableOrUnknown(
              data['pain_relief_status']!, _painReliefStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CycleEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      flowType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flow_type'])!,
      bloodColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blood_color']),
      clotSize: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clot_size'])!,
      isFlooding: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_flooding'])!,
      symptoms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptoms']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isTrueCycleStart: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_true_cycle_start'])!,
      painReliefStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pain_relief_status']),
    );
  }

  @override
  $CycleEventsTable createAlias(String alias) {
    return $CycleEventsTable(attachedDatabase, alias);
  }
}

class CycleEvent extends DataClass implements Insertable<CycleEvent> {
  final int id;
  final DateTime date;
  final String flowType;
  final String? bloodColor;
  final String clotSize;
  final bool isFlooding;
  final String? symptoms;
  final String? notes;
  final bool isTrueCycleStart;
  final String? painReliefStatus;
  const CycleEvent(
      {required this.id,
      required this.date,
      required this.flowType,
      this.bloodColor,
      required this.clotSize,
      required this.isFlooding,
      this.symptoms,
      this.notes,
      required this.isTrueCycleStart,
      this.painReliefStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['flow_type'] = Variable<String>(flowType);
    if (!nullToAbsent || bloodColor != null) {
      map['blood_color'] = Variable<String>(bloodColor);
    }
    map['clot_size'] = Variable<String>(clotSize);
    map['is_flooding'] = Variable<bool>(isFlooding);
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_true_cycle_start'] = Variable<bool>(isTrueCycleStart);
    if (!nullToAbsent || painReliefStatus != null) {
      map['pain_relief_status'] = Variable<String>(painReliefStatus);
    }
    return map;
  }

  CycleEventsCompanion toCompanion(bool nullToAbsent) {
    return CycleEventsCompanion(
      id: Value(id),
      date: Value(date),
      flowType: Value(flowType),
      bloodColor: bloodColor == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodColor),
      clotSize: Value(clotSize),
      isFlooding: Value(isFlooding),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isTrueCycleStart: Value(isTrueCycleStart),
      painReliefStatus: painReliefStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(painReliefStatus),
    );
  }

  factory CycleEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleEvent(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      flowType: serializer.fromJson<String>(json['flowType']),
      bloodColor: serializer.fromJson<String?>(json['bloodColor']),
      clotSize: serializer.fromJson<String>(json['clotSize']),
      isFlooding: serializer.fromJson<bool>(json['isFlooding']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      notes: serializer.fromJson<String?>(json['notes']),
      isTrueCycleStart: serializer.fromJson<bool>(json['isTrueCycleStart']),
      painReliefStatus: serializer.fromJson<String?>(json['painReliefStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'flowType': serializer.toJson<String>(flowType),
      'bloodColor': serializer.toJson<String?>(bloodColor),
      'clotSize': serializer.toJson<String>(clotSize),
      'isFlooding': serializer.toJson<bool>(isFlooding),
      'symptoms': serializer.toJson<String?>(symptoms),
      'notes': serializer.toJson<String?>(notes),
      'isTrueCycleStart': serializer.toJson<bool>(isTrueCycleStart),
      'painReliefStatus': serializer.toJson<String?>(painReliefStatus),
    };
  }

  CycleEvent copyWith(
          {int? id,
          DateTime? date,
          String? flowType,
          Value<String?> bloodColor = const Value.absent(),
          String? clotSize,
          bool? isFlooding,
          Value<String?> symptoms = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isTrueCycleStart,
          Value<String?> painReliefStatus = const Value.absent()}) =>
      CycleEvent(
        id: id ?? this.id,
        date: date ?? this.date,
        flowType: flowType ?? this.flowType,
        bloodColor: bloodColor.present ? bloodColor.value : this.bloodColor,
        clotSize: clotSize ?? this.clotSize,
        isFlooding: isFlooding ?? this.isFlooding,
        symptoms: symptoms.present ? symptoms.value : this.symptoms,
        notes: notes.present ? notes.value : this.notes,
        isTrueCycleStart: isTrueCycleStart ?? this.isTrueCycleStart,
        painReliefStatus: painReliefStatus.present
            ? painReliefStatus.value
            : this.painReliefStatus,
      );
  CycleEvent copyWithCompanion(CycleEventsCompanion data) {
    return CycleEvent(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      flowType: data.flowType.present ? data.flowType.value : this.flowType,
      bloodColor:
          data.bloodColor.present ? data.bloodColor.value : this.bloodColor,
      clotSize: data.clotSize.present ? data.clotSize.value : this.clotSize,
      isFlooding:
          data.isFlooding.present ? data.isFlooding.value : this.isFlooding,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      notes: data.notes.present ? data.notes.value : this.notes,
      isTrueCycleStart: data.isTrueCycleStart.present
          ? data.isTrueCycleStart.value
          : this.isTrueCycleStart,
      painReliefStatus: data.painReliefStatus.present
          ? data.painReliefStatus.value
          : this.painReliefStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleEvent(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('flowType: $flowType, ')
          ..write('bloodColor: $bloodColor, ')
          ..write('clotSize: $clotSize, ')
          ..write('isFlooding: $isFlooding, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('isTrueCycleStart: $isTrueCycleStart, ')
          ..write('painReliefStatus: $painReliefStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, flowType, bloodColor, clotSize,
      isFlooding, symptoms, notes, isTrueCycleStart, painReliefStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleEvent &&
          other.id == this.id &&
          other.date == this.date &&
          other.flowType == this.flowType &&
          other.bloodColor == this.bloodColor &&
          other.clotSize == this.clotSize &&
          other.isFlooding == this.isFlooding &&
          other.symptoms == this.symptoms &&
          other.notes == this.notes &&
          other.isTrueCycleStart == this.isTrueCycleStart &&
          other.painReliefStatus == this.painReliefStatus);
}

class CycleEventsCompanion extends UpdateCompanion<CycleEvent> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> flowType;
  final Value<String?> bloodColor;
  final Value<String> clotSize;
  final Value<bool> isFlooding;
  final Value<String?> symptoms;
  final Value<String?> notes;
  final Value<bool> isTrueCycleStart;
  final Value<String?> painReliefStatus;
  const CycleEventsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.flowType = const Value.absent(),
    this.bloodColor = const Value.absent(),
    this.clotSize = const Value.absent(),
    this.isFlooding = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.isTrueCycleStart = const Value.absent(),
    this.painReliefStatus = const Value.absent(),
  });
  CycleEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String flowType,
    this.bloodColor = const Value.absent(),
    this.clotSize = const Value.absent(),
    this.isFlooding = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.isTrueCycleStart = const Value.absent(),
    this.painReliefStatus = const Value.absent(),
  })  : date = Value(date),
        flowType = Value(flowType);
  static Insertable<CycleEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? flowType,
    Expression<String>? bloodColor,
    Expression<String>? clotSize,
    Expression<bool>? isFlooding,
    Expression<String>? symptoms,
    Expression<String>? notes,
    Expression<bool>? isTrueCycleStart,
    Expression<String>? painReliefStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (flowType != null) 'flow_type': flowType,
      if (bloodColor != null) 'blood_color': bloodColor,
      if (clotSize != null) 'clot_size': clotSize,
      if (isFlooding != null) 'is_flooding': isFlooding,
      if (symptoms != null) 'symptoms': symptoms,
      if (notes != null) 'notes': notes,
      if (isTrueCycleStart != null) 'is_true_cycle_start': isTrueCycleStart,
      if (painReliefStatus != null) 'pain_relief_status': painReliefStatus,
    });
  }

  CycleEventsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? flowType,
      Value<String?>? bloodColor,
      Value<String>? clotSize,
      Value<bool>? isFlooding,
      Value<String?>? symptoms,
      Value<String?>? notes,
      Value<bool>? isTrueCycleStart,
      Value<String?>? painReliefStatus}) {
    return CycleEventsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      flowType: flowType ?? this.flowType,
      bloodColor: bloodColor ?? this.bloodColor,
      clotSize: clotSize ?? this.clotSize,
      isFlooding: isFlooding ?? this.isFlooding,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      isTrueCycleStart: isTrueCycleStart ?? this.isTrueCycleStart,
      painReliefStatus: painReliefStatus ?? this.painReliefStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (flowType.present) {
      map['flow_type'] = Variable<String>(flowType.value);
    }
    if (bloodColor.present) {
      map['blood_color'] = Variable<String>(bloodColor.value);
    }
    if (clotSize.present) {
      map['clot_size'] = Variable<String>(clotSize.value);
    }
    if (isFlooding.present) {
      map['is_flooding'] = Variable<bool>(isFlooding.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isTrueCycleStart.present) {
      map['is_true_cycle_start'] = Variable<bool>(isTrueCycleStart.value);
    }
    if (painReliefStatus.present) {
      map['pain_relief_status'] = Variable<String>(painReliefStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CycleEventsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('flowType: $flowType, ')
          ..write('bloodColor: $bloodColor, ')
          ..write('clotSize: $clotSize, ')
          ..write('isFlooding: $isFlooding, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('isTrueCycleStart: $isTrueCycleStart, ')
          ..write('painReliefStatus: $painReliefStatus')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _regimenTypeMeta =
      const VerificationMeta('regimenType');
  @override
  late final GeneratedColumn<String> regimenType = GeneratedColumn<String>(
      'regimen_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeDaysMeta =
      const VerificationMeta('activeDays');
  @override
  late final GeneratedColumn<int> activeDays = GeneratedColumn<int>(
      'active_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(21));
  static const VerificationMeta _breakDaysMeta =
      const VerificationMeta('breakDays');
  @override
  late final GeneratedColumn<int> breakDays = GeneratedColumn<int>(
      'break_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(7));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
      'reminder_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        regimenType,
        activeDays,
        breakDays,
        startDate,
        reminderTime,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(Insertable<Routine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('regimen_type')) {
      context.handle(
          _regimenTypeMeta,
          regimenType.isAcceptableOrUnknown(
              data['regimen_type']!, _regimenTypeMeta));
    } else if (isInserting) {
      context.missing(_regimenTypeMeta);
    }
    if (data.containsKey('active_days')) {
      context.handle(
          _activeDaysMeta,
          activeDays.isAcceptableOrUnknown(
              data['active_days']!, _activeDaysMeta));
    }
    if (data.containsKey('break_days')) {
      context.handle(_breakDaysMeta,
          breakDays.isAcceptableOrUnknown(data['break_days']!, _breakDaysMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    } else if (isInserting) {
      context.missing(_reminderTimeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      regimenType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}regimen_type'])!,
      activeDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}active_days'])!,
      breakDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}break_days'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_time'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final int id;
  final String name;
  final String regimenType;
  final int activeDays;
  final int breakDays;
  final DateTime startDate;
  final String reminderTime;
  final bool isActive;
  const Routine(
      {required this.id,
      required this.name,
      required this.regimenType,
      required this.activeDays,
      required this.breakDays,
      required this.startDate,
      required this.reminderTime,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['regimen_type'] = Variable<String>(regimenType);
    map['active_days'] = Variable<int>(activeDays);
    map['break_days'] = Variable<int>(breakDays);
    map['start_date'] = Variable<DateTime>(startDate);
    map['reminder_time'] = Variable<String>(reminderTime);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      regimenType: Value(regimenType),
      activeDays: Value(activeDays),
      breakDays: Value(breakDays),
      startDate: Value(startDate),
      reminderTime: Value(reminderTime),
      isActive: Value(isActive),
    );
  }

  factory Routine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      regimenType: serializer.fromJson<String>(json['regimenType']),
      activeDays: serializer.fromJson<int>(json['activeDays']),
      breakDays: serializer.fromJson<int>(json['breakDays']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      reminderTime: serializer.fromJson<String>(json['reminderTime']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'regimenType': serializer.toJson<String>(regimenType),
      'activeDays': serializer.toJson<int>(activeDays),
      'breakDays': serializer.toJson<int>(breakDays),
      'startDate': serializer.toJson<DateTime>(startDate),
      'reminderTime': serializer.toJson<String>(reminderTime),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Routine copyWith(
          {int? id,
          String? name,
          String? regimenType,
          int? activeDays,
          int? breakDays,
          DateTime? startDate,
          String? reminderTime,
          bool? isActive}) =>
      Routine(
        id: id ?? this.id,
        name: name ?? this.name,
        regimenType: regimenType ?? this.regimenType,
        activeDays: activeDays ?? this.activeDays,
        breakDays: breakDays ?? this.breakDays,
        startDate: startDate ?? this.startDate,
        reminderTime: reminderTime ?? this.reminderTime,
        isActive: isActive ?? this.isActive,
      );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      regimenType:
          data.regimenType.present ? data.regimenType.value : this.regimenType,
      activeDays:
          data.activeDays.present ? data.activeDays.value : this.activeDays,
      breakDays: data.breakDays.present ? data.breakDays.value : this.breakDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('regimenType: $regimenType, ')
          ..write('activeDays: $activeDays, ')
          ..write('breakDays: $breakDays, ')
          ..write('startDate: $startDate, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, regimenType, activeDays, breakDays,
      startDate, reminderTime, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.regimenType == this.regimenType &&
          other.activeDays == this.activeDays &&
          other.breakDays == this.breakDays &&
          other.startDate == this.startDate &&
          other.reminderTime == this.reminderTime &&
          other.isActive == this.isActive);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> regimenType;
  final Value<int> activeDays;
  final Value<int> breakDays;
  final Value<DateTime> startDate;
  final Value<String> reminderTime;
  final Value<bool> isActive;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.regimenType = const Value.absent(),
    this.activeDays = const Value.absent(),
    this.breakDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String regimenType,
    this.activeDays = const Value.absent(),
    this.breakDays = const Value.absent(),
    required DateTime startDate,
    required String reminderTime,
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        regimenType = Value(regimenType),
        startDate = Value(startDate),
        reminderTime = Value(reminderTime);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? regimenType,
    Expression<int>? activeDays,
    Expression<int>? breakDays,
    Expression<DateTime>? startDate,
    Expression<String>? reminderTime,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (regimenType != null) 'regimen_type': regimenType,
      if (activeDays != null) 'active_days': activeDays,
      if (breakDays != null) 'break_days': breakDays,
      if (startDate != null) 'start_date': startDate,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RoutinesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? regimenType,
      Value<int>? activeDays,
      Value<int>? breakDays,
      Value<DateTime>? startDate,
      Value<String>? reminderTime,
      Value<bool>? isActive}) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      regimenType: regimenType ?? this.regimenType,
      activeDays: activeDays ?? this.activeDays,
      breakDays: breakDays ?? this.breakDays,
      startDate: startDate ?? this.startDate,
      reminderTime: reminderTime ?? this.reminderTime,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (regimenType.present) {
      map['regimen_type'] = Variable<String>(regimenType.value);
    }
    if (activeDays.present) {
      map['active_days'] = Variable<int>(activeDays.value);
    }
    if (breakDays.present) {
      map['break_days'] = Variable<int>(breakDays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('regimenType: $regimenType, ')
          ..write('activeDays: $activeDays, ')
          ..write('breakDays: $breakDays, ')
          ..write('startDate: $startDate, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $RoutineLogsTable extends RoutineLogs
    with TableInfo<$RoutineLogsTable, RoutineLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routineIdMeta =
      const VerificationMeta('routineId');
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
      'routine_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES routines (id)'));
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>('scheduled_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, routineId, scheduledDate, completedAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_logs';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(_routineIdMeta,
          routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta));
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}routine_id'])!,
      scheduledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $RoutineLogsTable createAlias(String alias) {
    return $RoutineLogsTable(attachedDatabase, alias);
  }
}

class RoutineLog extends DataClass implements Insertable<RoutineLog> {
  final int id;
  final int routineId;
  final DateTime scheduledDate;
  final DateTime? completedAt;
  final String status;
  const RoutineLog(
      {required this.id,
      required this.routineId,
      required this.scheduledDate,
      this.completedAt,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<int>(routineId);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  RoutineLogsCompanion toCompanion(bool nullToAbsent) {
    return RoutineLogsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      scheduledDate: Value(scheduledDate),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      status: Value(status),
    );
  }

  factory RoutineLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineLog(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<int>(json['routineId']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<int>(routineId),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  RoutineLog copyWith(
          {int? id,
          int? routineId,
          DateTime? scheduledDate,
          Value<DateTime?> completedAt = const Value.absent(),
          String? status}) =>
      RoutineLog(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        status: status ?? this.status,
      );
  RoutineLog copyWithCompanion(RoutineLogsCompanion data) {
    return RoutineLog(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineLog(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routineId, scheduledDate, completedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineLog &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.scheduledDate == this.scheduledDate &&
          other.completedAt == this.completedAt &&
          other.status == this.status);
}

class RoutineLogsCompanion extends UpdateCompanion<RoutineLog> {
  final Value<int> id;
  final Value<int> routineId;
  final Value<DateTime> scheduledDate;
  final Value<DateTime?> completedAt;
  final Value<String> status;
  const RoutineLogsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  RoutineLogsCompanion.insert({
    this.id = const Value.absent(),
    required int routineId,
    required DateTime scheduledDate,
    this.completedAt = const Value.absent(),
    required String status,
  })  : routineId = Value(routineId),
        scheduledDate = Value(scheduledDate),
        status = Value(status);
  static Insertable<RoutineLog> custom({
    Expression<int>? id,
    Expression<int>? routineId,
    Expression<DateTime>? scheduledDate,
    Expression<DateTime>? completedAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (status != null) 'status': status,
    });
  }

  RoutineLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? routineId,
      Value<DateTime>? scheduledDate,
      Value<DateTime?>? completedAt,
      Value<String>? status}) {
    return RoutineLogsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineLogsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $TreatmentInterventionsTable extends TreatmentInterventions
    with TableInfo<$TreatmentInterventionsTable, TreatmentIntervention> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentInterventionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, title, startDate, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treatment_interventions';
  @override
  VerificationContext validateIntegrity(
      Insertable<TreatmentIntervention> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreatmentIntervention map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreatmentIntervention(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $TreatmentInterventionsTable createAlias(String alias) {
    return $TreatmentInterventionsTable(attachedDatabase, alias);
  }
}

class TreatmentIntervention extends DataClass
    implements Insertable<TreatmentIntervention> {
  final int id;
  final String title;
  final DateTime startDate;
  final String? notes;
  const TreatmentIntervention(
      {required this.id,
      required this.title,
      required this.startDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TreatmentInterventionsCompanion toCompanion(bool nullToAbsent) {
    return TreatmentInterventionsCompanion(
      id: Value(id),
      title: Value(title),
      startDate: Value(startDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory TreatmentIntervention.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreatmentIntervention(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startDate': serializer.toJson<DateTime>(startDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TreatmentIntervention copyWith(
          {int? id,
          String? title,
          DateTime? startDate,
          Value<String?> notes = const Value.absent()}) =>
      TreatmentIntervention(
        id: id ?? this.id,
        title: title ?? this.title,
        startDate: startDate ?? this.startDate,
        notes: notes.present ? notes.value : this.notes,
      );
  TreatmentIntervention copyWithCompanion(
      TreatmentInterventionsCompanion data) {
    return TreatmentIntervention(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentIntervention(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, startDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreatmentIntervention &&
          other.id == this.id &&
          other.title == this.title &&
          other.startDate == this.startDate &&
          other.notes == this.notes);
}

class TreatmentInterventionsCompanion
    extends UpdateCompanion<TreatmentIntervention> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> startDate;
  final Value<String?> notes;
  const TreatmentInterventionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  TreatmentInterventionsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime startDate,
    this.notes = const Value.absent(),
  })  : title = Value(title),
        startDate = Value(startDate);
  static Insertable<TreatmentIntervention> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? startDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (notes != null) 'notes': notes,
    });
  }

  TreatmentInterventionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? startDate,
      Value<String?>? notes}) {
    return TreatmentInterventionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentInterventionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CycleEventsTable cycleEvents = $CycleEventsTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineLogsTable routineLogs = $RoutineLogsTable(this);
  late final $TreatmentInterventionsTable treatmentInterventions =
      $TreatmentInterventionsTable(this);
  late final Index idxCycleEventsDate = Index('idx_cycle_events_date',
      'CREATE INDEX idx_cycle_events_date ON cycle_events (date)');
  late final Index idxRoutineLogsDate = Index('idx_routine_logs_date',
      'CREATE INDEX idx_routine_logs_date ON routine_logs (scheduled_date)');
  late final CycleDao cycleDao = CycleDao(this as AppDatabase);
  late final RoutineDao routineDao = RoutineDao(this as AppDatabase);
  late final ReportDao reportDao = ReportDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        cycleEvents,
        routines,
        routineLogs,
        treatmentInterventions,
        idxCycleEventsDate,
        idxRoutineLogsDate
      ];
}

typedef $$CycleEventsTableCreateCompanionBuilder = CycleEventsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required String flowType,
  Value<String?> bloodColor,
  Value<String> clotSize,
  Value<bool> isFlooding,
  Value<String?> symptoms,
  Value<String?> notes,
  Value<bool> isTrueCycleStart,
  Value<String?> painReliefStatus,
});
typedef $$CycleEventsTableUpdateCompanionBuilder = CycleEventsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> flowType,
  Value<String?> bloodColor,
  Value<String> clotSize,
  Value<bool> isFlooding,
  Value<String?> symptoms,
  Value<String?> notes,
  Value<bool> isTrueCycleStart,
  Value<String?> painReliefStatus,
});

class $$CycleEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CycleEventsTable> {
  $$CycleEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flowType => $composableBuilder(
      column: $table.flowType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bloodColor => $composableBuilder(
      column: $table.bloodColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clotSize => $composableBuilder(
      column: $table.clotSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFlooding => $composableBuilder(
      column: $table.isFlooding, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTrueCycleStart => $composableBuilder(
      column: $table.isTrueCycleStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get painReliefStatus => $composableBuilder(
      column: $table.painReliefStatus,
      builder: (column) => ColumnFilters(column));
}

class $$CycleEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CycleEventsTable> {
  $$CycleEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flowType => $composableBuilder(
      column: $table.flowType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bloodColor => $composableBuilder(
      column: $table.bloodColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clotSize => $composableBuilder(
      column: $table.clotSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFlooding => $composableBuilder(
      column: $table.isFlooding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTrueCycleStart => $composableBuilder(
      column: $table.isTrueCycleStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get painReliefStatus => $composableBuilder(
      column: $table.painReliefStatus,
      builder: (column) => ColumnOrderings(column));
}

class $$CycleEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CycleEventsTable> {
  $$CycleEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get flowType =>
      $composableBuilder(column: $table.flowType, builder: (column) => column);

  GeneratedColumn<String> get bloodColor => $composableBuilder(
      column: $table.bloodColor, builder: (column) => column);

  GeneratedColumn<String> get clotSize =>
      $composableBuilder(column: $table.clotSize, builder: (column) => column);

  GeneratedColumn<bool> get isFlooding => $composableBuilder(
      column: $table.isFlooding, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isTrueCycleStart => $composableBuilder(
      column: $table.isTrueCycleStart, builder: (column) => column);

  GeneratedColumn<String> get painReliefStatus => $composableBuilder(
      column: $table.painReliefStatus, builder: (column) => column);
}

class $$CycleEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CycleEventsTable,
    CycleEvent,
    $$CycleEventsTableFilterComposer,
    $$CycleEventsTableOrderingComposer,
    $$CycleEventsTableAnnotationComposer,
    $$CycleEventsTableCreateCompanionBuilder,
    $$CycleEventsTableUpdateCompanionBuilder,
    (CycleEvent, BaseReferences<_$AppDatabase, $CycleEventsTable, CycleEvent>),
    CycleEvent,
    PrefetchHooks Function()> {
  $$CycleEventsTableTableManager(_$AppDatabase db, $CycleEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CycleEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CycleEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CycleEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> flowType = const Value.absent(),
            Value<String?> bloodColor = const Value.absent(),
            Value<String> clotSize = const Value.absent(),
            Value<bool> isFlooding = const Value.absent(),
            Value<String?> symptoms = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isTrueCycleStart = const Value.absent(),
            Value<String?> painReliefStatus = const Value.absent(),
          }) =>
              CycleEventsCompanion(
            id: id,
            date: date,
            flowType: flowType,
            bloodColor: bloodColor,
            clotSize: clotSize,
            isFlooding: isFlooding,
            symptoms: symptoms,
            notes: notes,
            isTrueCycleStart: isTrueCycleStart,
            painReliefStatus: painReliefStatus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String flowType,
            Value<String?> bloodColor = const Value.absent(),
            Value<String> clotSize = const Value.absent(),
            Value<bool> isFlooding = const Value.absent(),
            Value<String?> symptoms = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isTrueCycleStart = const Value.absent(),
            Value<String?> painReliefStatus = const Value.absent(),
          }) =>
              CycleEventsCompanion.insert(
            id: id,
            date: date,
            flowType: flowType,
            bloodColor: bloodColor,
            clotSize: clotSize,
            isFlooding: isFlooding,
            symptoms: symptoms,
            notes: notes,
            isTrueCycleStart: isTrueCycleStart,
            painReliefStatus: painReliefStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CycleEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CycleEventsTable,
    CycleEvent,
    $$CycleEventsTableFilterComposer,
    $$CycleEventsTableOrderingComposer,
    $$CycleEventsTableAnnotationComposer,
    $$CycleEventsTableCreateCompanionBuilder,
    $$CycleEventsTableUpdateCompanionBuilder,
    (CycleEvent, BaseReferences<_$AppDatabase, $CycleEventsTable, CycleEvent>),
    CycleEvent,
    PrefetchHooks Function()>;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  required String name,
  required String regimenType,
  Value<int> activeDays,
  Value<int> breakDays,
  required DateTime startDate,
  required String reminderTime,
  Value<bool> isActive,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> regimenType,
  Value<int> activeDays,
  Value<int> breakDays,
  Value<DateTime> startDate,
  Value<String> reminderTime,
  Value<bool> isActive,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineLogsTable, List<RoutineLog>>
      _routineLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.routineLogs,
              aliasName: 'routines__id__routine_logs__routine_id');

  $$RoutineLogsTableProcessedTableManager get routineLogsRefs {
    final manager = $$RoutineLogsTableTableManager($_db, $_db.routineLogs)
        .filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_routineLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get regimenType => $composableBuilder(
      column: $table.regimenType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activeDays => $composableBuilder(
      column: $table.activeDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get breakDays => $composableBuilder(
      column: $table.breakDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> routineLogsRefs(
      Expression<bool> Function($$RoutineLogsTableFilterComposer f) f) {
    final $$RoutineLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineLogs,
        getReferencedColumn: (t) => t.routineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineLogsTableFilterComposer(
              $db: $db,
              $table: $db.routineLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get regimenType => $composableBuilder(
      column: $table.regimenType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activeDays => $composableBuilder(
      column: $table.activeDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get breakDays => $composableBuilder(
      column: $table.breakDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get regimenType => $composableBuilder(
      column: $table.regimenType, builder: (column) => column);

  GeneratedColumn<int> get activeDays => $composableBuilder(
      column: $table.activeDays, builder: (column) => column);

  GeneratedColumn<int> get breakDays =>
      $composableBuilder(column: $table.breakDays, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> routineLogsRefs<T extends Object>(
      Expression<T> Function($$RoutineLogsTableAnnotationComposer a) f) {
    final $$RoutineLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineLogs,
        getReferencedColumn: (t) => t.routineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.routineLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutinesTable,
    Routine,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableAnnotationComposer,
    $$RoutinesTableCreateCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder,
    (Routine, $$RoutinesTableReferences),
    Routine,
    PrefetchHooks Function({bool routineLogsRefs})> {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> regimenType = const Value.absent(),
            Value<int> activeDays = const Value.absent(),
            Value<int> breakDays = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<String> reminderTime = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              RoutinesCompanion(
            id: id,
            name: name,
            regimenType: regimenType,
            activeDays: activeDays,
            breakDays: breakDays,
            startDate: startDate,
            reminderTime: reminderTime,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String regimenType,
            Value<int> activeDays = const Value.absent(),
            Value<int> breakDays = const Value.absent(),
            required DateTime startDate,
            required String reminderTime,
            Value<bool> isActive = const Value.absent(),
          }) =>
              RoutinesCompanion.insert(
            id: id,
            name: name,
            regimenType: regimenType,
            activeDays: activeDays,
            breakDays: breakDays,
            startDate: startDate,
            reminderTime: reminderTime,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RoutinesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({routineLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (routineLogsRefs) db.routineLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineLogsRefs)
                    await $_getPrefetchedData<Routine, $RoutinesTable,
                            RoutineLog>(
                        currentTable: table,
                        referencedTable:
                            $$RoutinesTableReferences._routineLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutinesTableReferences(db, table, p0)
                                .routineLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.routineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoutinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutinesTable,
    Routine,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableAnnotationComposer,
    $$RoutinesTableCreateCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder,
    (Routine, $$RoutinesTableReferences),
    Routine,
    PrefetchHooks Function({bool routineLogsRefs})>;
typedef $$RoutineLogsTableCreateCompanionBuilder = RoutineLogsCompanion
    Function({
  Value<int> id,
  required int routineId,
  required DateTime scheduledDate,
  Value<DateTime?> completedAt,
  required String status,
});
typedef $$RoutineLogsTableUpdateCompanionBuilder = RoutineLogsCompanion
    Function({
  Value<int> id,
  Value<int> routineId,
  Value<DateTime> scheduledDate,
  Value<DateTime?> completedAt,
  Value<String> status,
});

final class $$RoutineLogsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineLogsTable, RoutineLog> {
  $$RoutineLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_logs__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager($_db, $_db.routines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutineLogsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineLogsTable> {
  $$RoutineLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableFilterComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineLogsTable> {
  $$RoutineLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableOrderingComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineLogsTable> {
  $$RoutineLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableAnnotationComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineLogsTable,
    RoutineLog,
    $$RoutineLogsTableFilterComposer,
    $$RoutineLogsTableOrderingComposer,
    $$RoutineLogsTableAnnotationComposer,
    $$RoutineLogsTableCreateCompanionBuilder,
    $$RoutineLogsTableUpdateCompanionBuilder,
    (RoutineLog, $$RoutineLogsTableReferences),
    RoutineLog,
    PrefetchHooks Function({bool routineId})> {
  $$RoutineLogsTableTableManager(_$AppDatabase db, $RoutineLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> routineId = const Value.absent(),
            Value<DateTime> scheduledDate = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              RoutineLogsCompanion(
            id: id,
            routineId: routineId,
            scheduledDate: scheduledDate,
            completedAt: completedAt,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int routineId,
            required DateTime scheduledDate,
            Value<DateTime?> completedAt = const Value.absent(),
            required String status,
          }) =>
              RoutineLogsCompanion.insert(
            id: id,
            routineId: routineId,
            scheduledDate: scheduledDate,
            completedAt: completedAt,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RoutineLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (routineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.routineId,
                    referencedTable:
                        $$RoutineLogsTableReferences._routineIdTable(db),
                    referencedColumn:
                        $$RoutineLogsTableReferences._routineIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoutineLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineLogsTable,
    RoutineLog,
    $$RoutineLogsTableFilterComposer,
    $$RoutineLogsTableOrderingComposer,
    $$RoutineLogsTableAnnotationComposer,
    $$RoutineLogsTableCreateCompanionBuilder,
    $$RoutineLogsTableUpdateCompanionBuilder,
    (RoutineLog, $$RoutineLogsTableReferences),
    RoutineLog,
    PrefetchHooks Function({bool routineId})>;
typedef $$TreatmentInterventionsTableCreateCompanionBuilder
    = TreatmentInterventionsCompanion Function({
  Value<int> id,
  required String title,
  required DateTime startDate,
  Value<String?> notes,
});
typedef $$TreatmentInterventionsTableUpdateCompanionBuilder
    = TreatmentInterventionsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<DateTime> startDate,
  Value<String?> notes,
});

class $$TreatmentInterventionsTableFilterComposer
    extends Composer<_$AppDatabase, $TreatmentInterventionsTable> {
  $$TreatmentInterventionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$TreatmentInterventionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TreatmentInterventionsTable> {
  $$TreatmentInterventionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$TreatmentInterventionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreatmentInterventionsTable> {
  $$TreatmentInterventionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TreatmentInterventionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TreatmentInterventionsTable,
    TreatmentIntervention,
    $$TreatmentInterventionsTableFilterComposer,
    $$TreatmentInterventionsTableOrderingComposer,
    $$TreatmentInterventionsTableAnnotationComposer,
    $$TreatmentInterventionsTableCreateCompanionBuilder,
    $$TreatmentInterventionsTableUpdateCompanionBuilder,
    (
      TreatmentIntervention,
      BaseReferences<_$AppDatabase, $TreatmentInterventionsTable,
          TreatmentIntervention>
    ),
    TreatmentIntervention,
    PrefetchHooks Function()> {
  $$TreatmentInterventionsTableTableManager(
      _$AppDatabase db, $TreatmentInterventionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentInterventionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentInterventionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentInterventionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              TreatmentInterventionsCompanion(
            id: id,
            title: title,
            startDate: startDate,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required DateTime startDate,
            Value<String?> notes = const Value.absent(),
          }) =>
              TreatmentInterventionsCompanion.insert(
            id: id,
            title: title,
            startDate: startDate,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TreatmentInterventionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TreatmentInterventionsTable,
        TreatmentIntervention,
        $$TreatmentInterventionsTableFilterComposer,
        $$TreatmentInterventionsTableOrderingComposer,
        $$TreatmentInterventionsTableAnnotationComposer,
        $$TreatmentInterventionsTableCreateCompanionBuilder,
        $$TreatmentInterventionsTableUpdateCompanionBuilder,
        (
          TreatmentIntervention,
          BaseReferences<_$AppDatabase, $TreatmentInterventionsTable,
              TreatmentIntervention>
        ),
        TreatmentIntervention,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CycleEventsTableTableManager get cycleEvents =>
      $$CycleEventsTableTableManager(_db, _db.cycleEvents);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineLogsTableTableManager get routineLogs =>
      $$RoutineLogsTableTableManager(_db, _db.routineLogs);
  $$TreatmentInterventionsTableTableManager get treatmentInterventions =>
      $$TreatmentInterventionsTableTableManager(
          _db, _db.treatmentInterventions);
}
