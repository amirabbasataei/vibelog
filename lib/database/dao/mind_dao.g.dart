// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_dao.dart';

// ignore_for_file: type=lint
mixin _$MindDaoMixin on DatabaseAccessor<AppDatabase> {
  $DrawingStrokesTable get drawingStrokes => attachedDatabase.drawingStrokes;
  $ThoughtDetailsTable get thoughtDetails => attachedDatabase.thoughtDetails;
  MindDaoManager get managers => MindDaoManager(this);
}

class MindDaoManager {
  final _$MindDaoMixin _db;
  MindDaoManager(this._db);
  $$DrawingStrokesTableTableManager get drawingStrokes =>
      $$DrawingStrokesTableTableManager(
          _db.attachedDatabase, _db.drawingStrokes);
  $$ThoughtDetailsTableTableManager get thoughtDetails =>
      $$ThoughtDetailsTableTableManager(
          _db.attachedDatabase, _db.thoughtDetails);
}
