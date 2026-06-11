import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/mood_entries_table.dart';
import 'tables/drawing_strokes_table.dart';
import 'tables/thought_details_table.dart';
import 'dao/mood_entries_dao.dart';
import 'dao/mind_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [MoodEntries, DrawingStrokes, ThoughtDetails],
  daos: [MoodEntriesDao, MindDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(drawingStrokes);
            await m.createTable(thoughtDetails);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vibelog.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
