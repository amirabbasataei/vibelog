import 'package:drift/drift.dart';

class MoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get description => text()();
  IntColumn get mood => integer()();
  IntColumn get energy => integer()();
  IntColumn get boredom => integer()();
}
