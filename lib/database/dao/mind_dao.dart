import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/drawing_strokes_table.dart';
import '../tables/thought_details_table.dart';

part 'mind_dao.g.dart';

@DriftAccessor(tables: [DrawingStrokes, ThoughtDetails])
class MindDao extends DatabaseAccessor<AppDatabase> with _$MindDaoMixin {
  MindDao(super.db);

  Future<List<DrawingStrokeRow>> getAllStrokes() =>
      (select(drawingStrokes)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

  Future<void> replaceAllStrokes(List<DrawingStrokesCompanion> rows) =>
      transaction(() async {
        await delete(drawingStrokes).go();
        for (final row in rows) {
          await into(drawingStrokes).insert(row);
        }
      });

  Future<List<ThoughtDetailRow>> getAllThoughtDetails() =>
      select(thoughtDetails).get();

  Future<void> upsertThoughtDetail(ThoughtDetailsCompanion row) =>
      into(thoughtDetails).insertOnConflictUpdate(row);

  Future<void> deleteThoughtDetails(List<String> shapeIds) =>
      (delete(thoughtDetails)..where((t) => t.shapeId.isIn(shapeIds))).go();

  Future<void> deleteAllMindData() => transaction(() async {
        await delete(drawingStrokes).go();
        await delete(thoughtDetails).go();
      });
}
