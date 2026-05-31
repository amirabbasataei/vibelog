import '../../../database/dao/mood_entries_dao.dart';
import '../../../shared/models/mood_entry.dart';

class GraphRepository {
  GraphRepository(this._dao);
  final MoodEntriesDao _dao;

  Future<List<MoodEntry>> getAllEntries() async {
    final rows = await _dao.getAllEntriesOnce();
    return rows.map(_toModel).toList();
  }

  static MoodEntry _toModel(row) => MoodEntry(
        id: row.id as int,
        timestamp: row.timestamp as DateTime,
        description: row.description as String,
        mood: row.mood as int,
        energy: row.energy as int,
        boredom: row.boredom as int,
      );
}
