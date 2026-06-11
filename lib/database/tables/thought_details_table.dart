import 'package:drift/drift.dart';

@DataClassName('ThoughtDetailRow')
class ThoughtDetails extends Table {
  TextColumn get shapeId => text()();
  TextColumn get cause => text().withDefault(const Constant(''))();
  TextColumn get root => text().withDefault(const Constant(''))();
  TextColumn get resolution => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {shapeId};
}
