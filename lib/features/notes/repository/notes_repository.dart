import 'package:drift/drift.dart' show Value;
import '../../../database/app_database.dart' show MoodEntriesCompanion;
import '../../../database/dao/mood_entries_dao.dart';
import '../../../shared/models/mood_entry.dart';

class NotesRepository {
  NotesRepository(this._dao);
  final MoodEntriesDao _dao;

  Stream<List<MoodEntry>> watchAll() =>
      _dao.watchAllEntries().map((rows) => rows.map(_toModel).toList());

  Future<MoodEntry?> getById(int id) async {
    final row = await _dao.getEntryById(id);
    return row == null ? null : _toModel(row);
  }

  Future<void> add(MoodEntry entry) => _dao.insertEntry(
        MoodEntriesCompanion.insert(
          timestamp: entry.timestamp,
          description: entry.description,
          mood: entry.mood,
        ),
      );

  Future<void> update(MoodEntry entry) => _dao.updateEntry(
        MoodEntriesCompanion(
          id: Value(entry.id),
          timestamp: Value(entry.timestamp),
          description: Value(entry.description),
          mood: Value(entry.mood),
        ),
      );

  Future<void> delete(int id) => _dao.deleteEntry(id);
  Future<void> deleteAll() => _dao.deleteAllEntries();

  static MoodEntry _toModel(row) => MoodEntry(
        id: row.id as int,
        timestamp: row.timestamp as DateTime,
        description: row.description as String,
        mood: row.mood as int,
      );
}
