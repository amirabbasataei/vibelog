// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
      'mood', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
      'energy', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _boredomMeta =
      const VerificationMeta('boredom');
  @override
  late final GeneratedColumn<int> boredom = GeneratedColumn<int>(
      'boredom', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, timestamp, description, mood, energy, boredom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MoodEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('energy')) {
      context.handle(_energyMeta,
          energy.isAcceptableOrUnknown(data['energy']!, _energyMeta));
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('boredom')) {
      context.handle(_boredomMeta,
          boredom.isAcceptableOrUnknown(data['boredom']!, _boredomMeta));
    } else if (isInserting) {
      context.missing(_boredomMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood'])!,
      energy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}energy'])!,
      boredom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}boredom'])!,
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final int id;
  final DateTime timestamp;
  final String description;
  final int mood;
  final int energy;
  final int boredom;
  const MoodEntry(
      {required this.id,
      required this.timestamp,
      required this.description,
      required this.mood,
      required this.energy,
      required this.boredom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['description'] = Variable<String>(description);
    map['mood'] = Variable<int>(mood);
    map['energy'] = Variable<int>(energy);
    map['boredom'] = Variable<int>(boredom);
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      description: Value(description),
      mood: Value(mood),
      energy: Value(energy),
      boredom: Value(boredom),
    );
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      description: serializer.fromJson<String>(json['description']),
      mood: serializer.fromJson<int>(json['mood']),
      energy: serializer.fromJson<int>(json['energy']),
      boredom: serializer.fromJson<int>(json['boredom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'description': serializer.toJson<String>(description),
      'mood': serializer.toJson<int>(mood),
      'energy': serializer.toJson<int>(energy),
      'boredom': serializer.toJson<int>(boredom),
    };
  }

  MoodEntry copyWith(
          {int? id,
          DateTime? timestamp,
          String? description,
          int? mood,
          int? energy,
          int? boredom}) =>
      MoodEntry(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        description: description ?? this.description,
        mood: mood ?? this.mood,
        energy: energy ?? this.energy,
        boredom: boredom ?? this.boredom,
      );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      description:
          data.description.present ? data.description.value : this.description,
      mood: data.mood.present ? data.mood.value : this.mood,
      energy: data.energy.present ? data.energy.value : this.energy,
      boredom: data.boredom.present ? data.boredom.value : this.boredom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('description: $description, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('boredom: $boredom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, description, mood, energy, boredom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.description == this.description &&
          other.mood == this.mood &&
          other.energy == this.energy &&
          other.boredom == this.boredom);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> description;
  final Value<int> mood;
  final Value<int> energy;
  final Value<int> boredom;
  const MoodEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.description = const Value.absent(),
    this.mood = const Value.absent(),
    this.energy = const Value.absent(),
    this.boredom = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required String description,
    required int mood,
    required int energy,
    required int boredom,
  })  : timestamp = Value(timestamp),
        description = Value(description),
        mood = Value(mood),
        energy = Value(energy),
        boredom = Value(boredom);
  static Insertable<MoodEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? description,
    Expression<int>? mood,
    Expression<int>? energy,
    Expression<int>? boredom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (description != null) 'description': description,
      if (mood != null) 'mood': mood,
      if (energy != null) 'energy': energy,
      if (boredom != null) 'boredom': boredom,
    });
  }

  MoodEntriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? timestamp,
      Value<String>? description,
      Value<int>? mood,
      Value<int>? energy,
      Value<int>? boredom}) {
    return MoodEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      boredom: boredom ?? this.boredom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (boredom.present) {
      map['boredom'] = Variable<int>(boredom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('description: $description, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('boredom: $boredom')
          ..write(')'))
        .toString();
  }
}

class $DrawingStrokesTable extends DrawingStrokes
    with TableInfo<$DrawingStrokesTable, DrawingStrokeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrawingStrokesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _shapeIdMeta =
      const VerificationMeta('shapeId');
  @override
  late final GeneratedColumn<String> shapeId = GeneratedColumn<String>(
      'shape_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pointsJsonMeta =
      const VerificationMeta('pointsJson');
  @override
  late final GeneratedColumn<String> pointsJson = GeneratedColumn<String>(
      'points_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorArgbMeta =
      const VerificationMeta('colorArgb');
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
      'color_argb', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _strokeWidthMeta =
      const VerificationMeta('strokeWidth');
  @override
  late final GeneratedColumn<double> strokeWidth = GeneratedColumn<double>(
      'stroke_width', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isEraserMeta =
      const VerificationMeta('isEraser');
  @override
  late final GeneratedColumn<bool> isEraser = GeneratedColumn<bool>(
      'is_eraser', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_eraser" IN (0, 1))'));
  static const VerificationMeta _isClosedMeta =
      const VerificationMeta('isClosed');
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
      'is_closed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_closed" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shapeId,
        title,
        pointsJson,
        colorArgb,
        strokeWidth,
        isEraser,
        isClosed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drawing_strokes';
  @override
  VerificationContext validateIntegrity(Insertable<DrawingStrokeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shape_id')) {
      context.handle(_shapeIdMeta,
          shapeId.isAcceptableOrUnknown(data['shape_id']!, _shapeIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('points_json')) {
      context.handle(
          _pointsJsonMeta,
          pointsJson.isAcceptableOrUnknown(
              data['points_json']!, _pointsJsonMeta));
    } else if (isInserting) {
      context.missing(_pointsJsonMeta);
    }
    if (data.containsKey('color_argb')) {
      context.handle(_colorArgbMeta,
          colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta));
    } else if (isInserting) {
      context.missing(_colorArgbMeta);
    }
    if (data.containsKey('stroke_width')) {
      context.handle(
          _strokeWidthMeta,
          strokeWidth.isAcceptableOrUnknown(
              data['stroke_width']!, _strokeWidthMeta));
    } else if (isInserting) {
      context.missing(_strokeWidthMeta);
    }
    if (data.containsKey('is_eraser')) {
      context.handle(_isEraserMeta,
          isEraser.isAcceptableOrUnknown(data['is_eraser']!, _isEraserMeta));
    } else if (isInserting) {
      context.missing(_isEraserMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(_isClosedMeta,
          isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta));
    } else if (isInserting) {
      context.missing(_isClosedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrawingStrokeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrawingStrokeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      shapeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      pointsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}points_json'])!,
      colorArgb: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_argb'])!,
      strokeWidth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stroke_width'])!,
      isEraser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_eraser'])!,
      isClosed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_closed'])!,
    );
  }

  @override
  $DrawingStrokesTable createAlias(String alias) {
    return $DrawingStrokesTable(attachedDatabase, alias);
  }
}

class DrawingStrokeRow extends DataClass
    implements Insertable<DrawingStrokeRow> {
  final int id;
  final String? shapeId;
  final String? title;
  final String pointsJson;
  final int colorArgb;
  final double strokeWidth;
  final bool isEraser;
  final bool isClosed;
  const DrawingStrokeRow(
      {required this.id,
      this.shapeId,
      this.title,
      required this.pointsJson,
      required this.colorArgb,
      required this.strokeWidth,
      required this.isEraser,
      required this.isClosed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || shapeId != null) {
      map['shape_id'] = Variable<String>(shapeId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['points_json'] = Variable<String>(pointsJson);
    map['color_argb'] = Variable<int>(colorArgb);
    map['stroke_width'] = Variable<double>(strokeWidth);
    map['is_eraser'] = Variable<bool>(isEraser);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  DrawingStrokesCompanion toCompanion(bool nullToAbsent) {
    return DrawingStrokesCompanion(
      id: Value(id),
      shapeId: shapeId == null && nullToAbsent
          ? const Value.absent()
          : Value(shapeId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      pointsJson: Value(pointsJson),
      colorArgb: Value(colorArgb),
      strokeWidth: Value(strokeWidth),
      isEraser: Value(isEraser),
      isClosed: Value(isClosed),
    );
  }

  factory DrawingStrokeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrawingStrokeRow(
      id: serializer.fromJson<int>(json['id']),
      shapeId: serializer.fromJson<String?>(json['shapeId']),
      title: serializer.fromJson<String?>(json['title']),
      pointsJson: serializer.fromJson<String>(json['pointsJson']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      strokeWidth: serializer.fromJson<double>(json['strokeWidth']),
      isEraser: serializer.fromJson<bool>(json['isEraser']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shapeId': serializer.toJson<String?>(shapeId),
      'title': serializer.toJson<String?>(title),
      'pointsJson': serializer.toJson<String>(pointsJson),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'strokeWidth': serializer.toJson<double>(strokeWidth),
      'isEraser': serializer.toJson<bool>(isEraser),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  DrawingStrokeRow copyWith(
          {int? id,
          Value<String?> shapeId = const Value.absent(),
          Value<String?> title = const Value.absent(),
          String? pointsJson,
          int? colorArgb,
          double? strokeWidth,
          bool? isEraser,
          bool? isClosed}) =>
      DrawingStrokeRow(
        id: id ?? this.id,
        shapeId: shapeId.present ? shapeId.value : this.shapeId,
        title: title.present ? title.value : this.title,
        pointsJson: pointsJson ?? this.pointsJson,
        colorArgb: colorArgb ?? this.colorArgb,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        isEraser: isEraser ?? this.isEraser,
        isClosed: isClosed ?? this.isClosed,
      );
  DrawingStrokeRow copyWithCompanion(DrawingStrokesCompanion data) {
    return DrawingStrokeRow(
      id: data.id.present ? data.id.value : this.id,
      shapeId: data.shapeId.present ? data.shapeId.value : this.shapeId,
      title: data.title.present ? data.title.value : this.title,
      pointsJson:
          data.pointsJson.present ? data.pointsJson.value : this.pointsJson,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      strokeWidth:
          data.strokeWidth.present ? data.strokeWidth.value : this.strokeWidth,
      isEraser: data.isEraser.present ? data.isEraser.value : this.isEraser,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrawingStrokeRow(')
          ..write('id: $id, ')
          ..write('shapeId: $shapeId, ')
          ..write('title: $title, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('strokeWidth: $strokeWidth, ')
          ..write('isEraser: $isEraser, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shapeId, title, pointsJson, colorArgb,
      strokeWidth, isEraser, isClosed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrawingStrokeRow &&
          other.id == this.id &&
          other.shapeId == this.shapeId &&
          other.title == this.title &&
          other.pointsJson == this.pointsJson &&
          other.colorArgb == this.colorArgb &&
          other.strokeWidth == this.strokeWidth &&
          other.isEraser == this.isEraser &&
          other.isClosed == this.isClosed);
}

class DrawingStrokesCompanion extends UpdateCompanion<DrawingStrokeRow> {
  final Value<int> id;
  final Value<String?> shapeId;
  final Value<String?> title;
  final Value<String> pointsJson;
  final Value<int> colorArgb;
  final Value<double> strokeWidth;
  final Value<bool> isEraser;
  final Value<bool> isClosed;
  const DrawingStrokesCompanion({
    this.id = const Value.absent(),
    this.shapeId = const Value.absent(),
    this.title = const Value.absent(),
    this.pointsJson = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.strokeWidth = const Value.absent(),
    this.isEraser = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  DrawingStrokesCompanion.insert({
    this.id = const Value.absent(),
    this.shapeId = const Value.absent(),
    this.title = const Value.absent(),
    required String pointsJson,
    required int colorArgb,
    required double strokeWidth,
    required bool isEraser,
    required bool isClosed,
  })  : pointsJson = Value(pointsJson),
        colorArgb = Value(colorArgb),
        strokeWidth = Value(strokeWidth),
        isEraser = Value(isEraser),
        isClosed = Value(isClosed);
  static Insertable<DrawingStrokeRow> custom({
    Expression<int>? id,
    Expression<String>? shapeId,
    Expression<String>? title,
    Expression<String>? pointsJson,
    Expression<int>? colorArgb,
    Expression<double>? strokeWidth,
    Expression<bool>? isEraser,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shapeId != null) 'shape_id': shapeId,
      if (title != null) 'title': title,
      if (pointsJson != null) 'points_json': pointsJson,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (strokeWidth != null) 'stroke_width': strokeWidth,
      if (isEraser != null) 'is_eraser': isEraser,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  DrawingStrokesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? shapeId,
      Value<String?>? title,
      Value<String>? pointsJson,
      Value<int>? colorArgb,
      Value<double>? strokeWidth,
      Value<bool>? isEraser,
      Value<bool>? isClosed}) {
    return DrawingStrokesCompanion(
      id: id ?? this.id,
      shapeId: shapeId ?? this.shapeId,
      title: title ?? this.title,
      pointsJson: pointsJson ?? this.pointsJson,
      colorArgb: colorArgb ?? this.colorArgb,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isEraser: isEraser ?? this.isEraser,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shapeId.present) {
      map['shape_id'] = Variable<String>(shapeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pointsJson.present) {
      map['points_json'] = Variable<String>(pointsJson.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (strokeWidth.present) {
      map['stroke_width'] = Variable<double>(strokeWidth.value);
    }
    if (isEraser.present) {
      map['is_eraser'] = Variable<bool>(isEraser.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrawingStrokesCompanion(')
          ..write('id: $id, ')
          ..write('shapeId: $shapeId, ')
          ..write('title: $title, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('strokeWidth: $strokeWidth, ')
          ..write('isEraser: $isEraser, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $ThoughtDetailsTable extends ThoughtDetails
    with TableInfo<$ThoughtDetailsTable, ThoughtDetailRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThoughtDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _shapeIdMeta =
      const VerificationMeta('shapeId');
  @override
  late final GeneratedColumn<String> shapeId = GeneratedColumn<String>(
      'shape_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _causeMeta = const VerificationMeta('cause');
  @override
  late final GeneratedColumn<String> cause = GeneratedColumn<String>(
      'cause', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
      'root', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [shapeId, cause, root, resolution];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thought_details';
  @override
  VerificationContext validateIntegrity(Insertable<ThoughtDetailRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('shape_id')) {
      context.handle(_shapeIdMeta,
          shapeId.isAcceptableOrUnknown(data['shape_id']!, _shapeIdMeta));
    } else if (isInserting) {
      context.missing(_shapeIdMeta);
    }
    if (data.containsKey('cause')) {
      context.handle(
          _causeMeta, cause.isAcceptableOrUnknown(data['cause']!, _causeMeta));
    }
    if (data.containsKey('root')) {
      context.handle(
          _rootMeta, root.isAcceptableOrUnknown(data['root']!, _rootMeta));
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shapeId};
  @override
  ThoughtDetailRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThoughtDetailRow(
      shapeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape_id'])!,
      cause: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cause'])!,
      root: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}root'])!,
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution'])!,
    );
  }

  @override
  $ThoughtDetailsTable createAlias(String alias) {
    return $ThoughtDetailsTable(attachedDatabase, alias);
  }
}

class ThoughtDetailRow extends DataClass
    implements Insertable<ThoughtDetailRow> {
  final String shapeId;
  final String cause;
  final String root;
  final String resolution;
  const ThoughtDetailRow(
      {required this.shapeId,
      required this.cause,
      required this.root,
      required this.resolution});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['shape_id'] = Variable<String>(shapeId);
    map['cause'] = Variable<String>(cause);
    map['root'] = Variable<String>(root);
    map['resolution'] = Variable<String>(resolution);
    return map;
  }

  ThoughtDetailsCompanion toCompanion(bool nullToAbsent) {
    return ThoughtDetailsCompanion(
      shapeId: Value(shapeId),
      cause: Value(cause),
      root: Value(root),
      resolution: Value(resolution),
    );
  }

  factory ThoughtDetailRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThoughtDetailRow(
      shapeId: serializer.fromJson<String>(json['shapeId']),
      cause: serializer.fromJson<String>(json['cause']),
      root: serializer.fromJson<String>(json['root']),
      resolution: serializer.fromJson<String>(json['resolution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shapeId': serializer.toJson<String>(shapeId),
      'cause': serializer.toJson<String>(cause),
      'root': serializer.toJson<String>(root),
      'resolution': serializer.toJson<String>(resolution),
    };
  }

  ThoughtDetailRow copyWith(
          {String? shapeId, String? cause, String? root, String? resolution}) =>
      ThoughtDetailRow(
        shapeId: shapeId ?? this.shapeId,
        cause: cause ?? this.cause,
        root: root ?? this.root,
        resolution: resolution ?? this.resolution,
      );
  ThoughtDetailRow copyWithCompanion(ThoughtDetailsCompanion data) {
    return ThoughtDetailRow(
      shapeId: data.shapeId.present ? data.shapeId.value : this.shapeId,
      cause: data.cause.present ? data.cause.value : this.cause,
      root: data.root.present ? data.root.value : this.root,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtDetailRow(')
          ..write('shapeId: $shapeId, ')
          ..write('cause: $cause, ')
          ..write('root: $root, ')
          ..write('resolution: $resolution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(shapeId, cause, root, resolution);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThoughtDetailRow &&
          other.shapeId == this.shapeId &&
          other.cause == this.cause &&
          other.root == this.root &&
          other.resolution == this.resolution);
}

class ThoughtDetailsCompanion extends UpdateCompanion<ThoughtDetailRow> {
  final Value<String> shapeId;
  final Value<String> cause;
  final Value<String> root;
  final Value<String> resolution;
  final Value<int> rowid;
  const ThoughtDetailsCompanion({
    this.shapeId = const Value.absent(),
    this.cause = const Value.absent(),
    this.root = const Value.absent(),
    this.resolution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThoughtDetailsCompanion.insert({
    required String shapeId,
    this.cause = const Value.absent(),
    this.root = const Value.absent(),
    this.resolution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : shapeId = Value(shapeId);
  static Insertable<ThoughtDetailRow> custom({
    Expression<String>? shapeId,
    Expression<String>? cause,
    Expression<String>? root,
    Expression<String>? resolution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (shapeId != null) 'shape_id': shapeId,
      if (cause != null) 'cause': cause,
      if (root != null) 'root': root,
      if (resolution != null) 'resolution': resolution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThoughtDetailsCompanion copyWith(
      {Value<String>? shapeId,
      Value<String>? cause,
      Value<String>? root,
      Value<String>? resolution,
      Value<int>? rowid}) {
    return ThoughtDetailsCompanion(
      shapeId: shapeId ?? this.shapeId,
      cause: cause ?? this.cause,
      root: root ?? this.root,
      resolution: resolution ?? this.resolution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shapeId.present) {
      map['shape_id'] = Variable<String>(shapeId.value);
    }
    if (cause.present) {
      map['cause'] = Variable<String>(cause.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtDetailsCompanion(')
          ..write('shapeId: $shapeId, ')
          ..write('cause: $cause, ')
          ..write('root: $root, ')
          ..write('resolution: $resolution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $DrawingStrokesTable drawingStrokes = $DrawingStrokesTable(this);
  late final $ThoughtDetailsTable thoughtDetails = $ThoughtDetailsTable(this);
  late final MoodEntriesDao moodEntriesDao =
      MoodEntriesDao(this as AppDatabase);
  late final MindDao mindDao = MindDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [moodEntries, drawingStrokes, thoughtDetails];
}

typedef $$MoodEntriesTableCreateCompanionBuilder = MoodEntriesCompanion
    Function({
  Value<int> id,
  required DateTime timestamp,
  required String description,
  required int mood,
  required int energy,
  required int boredom,
});
typedef $$MoodEntriesTableUpdateCompanionBuilder = MoodEntriesCompanion
    Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<String> description,
  Value<int> mood,
  Value<int> energy,
  Value<int> boredom,
});

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get energy => $composableBuilder(
      column: $table.energy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get boredom => $composableBuilder(
      column: $table.boredom, builder: (column) => ColumnFilters(column));
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get energy => $composableBuilder(
      column: $table.energy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get boredom => $composableBuilder(
      column: $table.boredom, builder: (column) => ColumnOrderings(column));
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<int> get boredom =>
      $composableBuilder(column: $table.boredom, builder: (column) => column);
}

class $$MoodEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MoodEntriesTable,
    MoodEntry,
    $$MoodEntriesTableFilterComposer,
    $$MoodEntriesTableOrderingComposer,
    $$MoodEntriesTableAnnotationComposer,
    $$MoodEntriesTableCreateCompanionBuilder,
    $$MoodEntriesTableUpdateCompanionBuilder,
    (MoodEntry, BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>),
    MoodEntry,
    PrefetchHooks Function()> {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> mood = const Value.absent(),
            Value<int> energy = const Value.absent(),
            Value<int> boredom = const Value.absent(),
          }) =>
              MoodEntriesCompanion(
            id: id,
            timestamp: timestamp,
            description: description,
            mood: mood,
            energy: energy,
            boredom: boredom,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime timestamp,
            required String description,
            required int mood,
            required int energy,
            required int boredom,
          }) =>
              MoodEntriesCompanion.insert(
            id: id,
            timestamp: timestamp,
            description: description,
            mood: mood,
            energy: energy,
            boredom: boredom,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MoodEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MoodEntriesTable,
    MoodEntry,
    $$MoodEntriesTableFilterComposer,
    $$MoodEntriesTableOrderingComposer,
    $$MoodEntriesTableAnnotationComposer,
    $$MoodEntriesTableCreateCompanionBuilder,
    $$MoodEntriesTableUpdateCompanionBuilder,
    (MoodEntry, BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>),
    MoodEntry,
    PrefetchHooks Function()>;
typedef $$DrawingStrokesTableCreateCompanionBuilder = DrawingStrokesCompanion
    Function({
  Value<int> id,
  Value<String?> shapeId,
  Value<String?> title,
  required String pointsJson,
  required int colorArgb,
  required double strokeWidth,
  required bool isEraser,
  required bool isClosed,
});
typedef $$DrawingStrokesTableUpdateCompanionBuilder = DrawingStrokesCompanion
    Function({
  Value<int> id,
  Value<String?> shapeId,
  Value<String?> title,
  Value<String> pointsJson,
  Value<int> colorArgb,
  Value<double> strokeWidth,
  Value<bool> isEraser,
  Value<bool> isClosed,
});

class $$DrawingStrokesTableFilterComposer
    extends Composer<_$AppDatabase, $DrawingStrokesTable> {
  $$DrawingStrokesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shapeId => $composableBuilder(
      column: $table.shapeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pointsJson => $composableBuilder(
      column: $table.pointsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorArgb => $composableBuilder(
      column: $table.colorArgb, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get strokeWidth => $composableBuilder(
      column: $table.strokeWidth, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEraser => $composableBuilder(
      column: $table.isEraser, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnFilters(column));
}

class $$DrawingStrokesTableOrderingComposer
    extends Composer<_$AppDatabase, $DrawingStrokesTable> {
  $$DrawingStrokesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shapeId => $composableBuilder(
      column: $table.shapeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pointsJson => $composableBuilder(
      column: $table.pointsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorArgb => $composableBuilder(
      column: $table.colorArgb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get strokeWidth => $composableBuilder(
      column: $table.strokeWidth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEraser => $composableBuilder(
      column: $table.isEraser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnOrderings(column));
}

class $$DrawingStrokesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrawingStrokesTable> {
  $$DrawingStrokesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shapeId =>
      $composableBuilder(column: $table.shapeId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get pointsJson => $composableBuilder(
      column: $table.pointsJson, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<double> get strokeWidth => $composableBuilder(
      column: $table.strokeWidth, builder: (column) => column);

  GeneratedColumn<bool> get isEraser =>
      $composableBuilder(column: $table.isEraser, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);
}

class $$DrawingStrokesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DrawingStrokesTable,
    DrawingStrokeRow,
    $$DrawingStrokesTableFilterComposer,
    $$DrawingStrokesTableOrderingComposer,
    $$DrawingStrokesTableAnnotationComposer,
    $$DrawingStrokesTableCreateCompanionBuilder,
    $$DrawingStrokesTableUpdateCompanionBuilder,
    (
      DrawingStrokeRow,
      BaseReferences<_$AppDatabase, $DrawingStrokesTable, DrawingStrokeRow>
    ),
    DrawingStrokeRow,
    PrefetchHooks Function()> {
  $$DrawingStrokesTableTableManager(
      _$AppDatabase db, $DrawingStrokesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrawingStrokesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrawingStrokesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrawingStrokesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> shapeId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String> pointsJson = const Value.absent(),
            Value<int> colorArgb = const Value.absent(),
            Value<double> strokeWidth = const Value.absent(),
            Value<bool> isEraser = const Value.absent(),
            Value<bool> isClosed = const Value.absent(),
          }) =>
              DrawingStrokesCompanion(
            id: id,
            shapeId: shapeId,
            title: title,
            pointsJson: pointsJson,
            colorArgb: colorArgb,
            strokeWidth: strokeWidth,
            isEraser: isEraser,
            isClosed: isClosed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> shapeId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            required String pointsJson,
            required int colorArgb,
            required double strokeWidth,
            required bool isEraser,
            required bool isClosed,
          }) =>
              DrawingStrokesCompanion.insert(
            id: id,
            shapeId: shapeId,
            title: title,
            pointsJson: pointsJson,
            colorArgb: colorArgb,
            strokeWidth: strokeWidth,
            isEraser: isEraser,
            isClosed: isClosed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DrawingStrokesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DrawingStrokesTable,
    DrawingStrokeRow,
    $$DrawingStrokesTableFilterComposer,
    $$DrawingStrokesTableOrderingComposer,
    $$DrawingStrokesTableAnnotationComposer,
    $$DrawingStrokesTableCreateCompanionBuilder,
    $$DrawingStrokesTableUpdateCompanionBuilder,
    (
      DrawingStrokeRow,
      BaseReferences<_$AppDatabase, $DrawingStrokesTable, DrawingStrokeRow>
    ),
    DrawingStrokeRow,
    PrefetchHooks Function()>;
typedef $$ThoughtDetailsTableCreateCompanionBuilder = ThoughtDetailsCompanion
    Function({
  required String shapeId,
  Value<String> cause,
  Value<String> root,
  Value<String> resolution,
  Value<int> rowid,
});
typedef $$ThoughtDetailsTableUpdateCompanionBuilder = ThoughtDetailsCompanion
    Function({
  Value<String> shapeId,
  Value<String> cause,
  Value<String> root,
  Value<String> resolution,
  Value<int> rowid,
});

class $$ThoughtDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $ThoughtDetailsTable> {
  $$ThoughtDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get shapeId => $composableBuilder(
      column: $table.shapeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cause => $composableBuilder(
      column: $table.cause, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get root => $composableBuilder(
      column: $table.root, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));
}

class $$ThoughtDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThoughtDetailsTable> {
  $$ThoughtDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get shapeId => $composableBuilder(
      column: $table.shapeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cause => $composableBuilder(
      column: $table.cause, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get root => $composableBuilder(
      column: $table.root, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));
}

class $$ThoughtDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThoughtDetailsTable> {
  $$ThoughtDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get shapeId =>
      $composableBuilder(column: $table.shapeId, builder: (column) => column);

  GeneratedColumn<String> get cause =>
      $composableBuilder(column: $table.cause, builder: (column) => column);

  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);
}

class $$ThoughtDetailsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ThoughtDetailsTable,
    ThoughtDetailRow,
    $$ThoughtDetailsTableFilterComposer,
    $$ThoughtDetailsTableOrderingComposer,
    $$ThoughtDetailsTableAnnotationComposer,
    $$ThoughtDetailsTableCreateCompanionBuilder,
    $$ThoughtDetailsTableUpdateCompanionBuilder,
    (
      ThoughtDetailRow,
      BaseReferences<_$AppDatabase, $ThoughtDetailsTable, ThoughtDetailRow>
    ),
    ThoughtDetailRow,
    PrefetchHooks Function()> {
  $$ThoughtDetailsTableTableManager(
      _$AppDatabase db, $ThoughtDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThoughtDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThoughtDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThoughtDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> shapeId = const Value.absent(),
            Value<String> cause = const Value.absent(),
            Value<String> root = const Value.absent(),
            Value<String> resolution = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ThoughtDetailsCompanion(
            shapeId: shapeId,
            cause: cause,
            root: root,
            resolution: resolution,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String shapeId,
            Value<String> cause = const Value.absent(),
            Value<String> root = const Value.absent(),
            Value<String> resolution = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ThoughtDetailsCompanion.insert(
            shapeId: shapeId,
            cause: cause,
            root: root,
            resolution: resolution,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ThoughtDetailsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ThoughtDetailsTable,
    ThoughtDetailRow,
    $$ThoughtDetailsTableFilterComposer,
    $$ThoughtDetailsTableOrderingComposer,
    $$ThoughtDetailsTableAnnotationComposer,
    $$ThoughtDetailsTableCreateCompanionBuilder,
    $$ThoughtDetailsTableUpdateCompanionBuilder,
    (
      ThoughtDetailRow,
      BaseReferences<_$AppDatabase, $ThoughtDetailsTable, ThoughtDetailRow>
    ),
    ThoughtDetailRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$DrawingStrokesTableTableManager get drawingStrokes =>
      $$DrawingStrokesTableTableManager(_db, _db.drawingStrokes);
  $$ThoughtDetailsTableTableManager get thoughtDetails =>
      $$ThoughtDetailsTableTableManager(_db, _db.thoughtDetails);
}
