import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/mood_entries_table.dart';

part 'mood_entries_dao.g.dart';

@DriftAccessor(tables: [MoodEntries])
class MoodEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$MoodEntriesDaoMixin {
  MoodEntriesDao(super.db);

  Stream<List<MoodEntry>> watchAllEntries() =>
      (select(moodEntries)..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .watch();

  Future<List<MoodEntry>> getAllEntriesOnce() =>
      (select(moodEntries)..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .get();

  Future<void> insertEntry(MoodEntriesCompanion entry) =>
      into(moodEntries).insert(entry);

  Future<void> updateEntry(MoodEntriesCompanion entry) =>
      (update(moodEntries)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> deleteEntry(int id) =>
      (delete(moodEntries)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAllEntries() => delete(moodEntries).go();

  Future<MoodEntry?> getEntryById(int id) =>
      (select(moodEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
}
