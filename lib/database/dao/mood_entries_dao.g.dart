// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entries_dao.dart';

// ignore_for_file: type=lint
mixin _$MoodEntriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $MoodEntriesTable get moodEntries => attachedDatabase.moodEntries;
  MoodEntriesDaoManager get managers => MoodEntriesDaoManager(this);
}

class MoodEntriesDaoManager {
  final _$MoodEntriesDaoMixin _db;
  MoodEntriesDaoManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db.attachedDatabase, _db.moodEntries);
}
