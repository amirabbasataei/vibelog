import 'package:drift/drift.dart';

@DataClassName('DrawingStrokeRow')
class DrawingStrokes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get shapeId => text().nullable()();
  TextColumn get title => text().nullable()();
  // JSON-encoded list of [x, y] pairs: [[1.0,2.0],[3.0,4.0],...]
  TextColumn get pointsJson => text()();
  IntColumn get colorArgb => integer()();
  RealColumn get strokeWidth => real()();
  BoolColumn get isEraser => boolean()();
  BoolColumn get isClosed => boolean()();
}
