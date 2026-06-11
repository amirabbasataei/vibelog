import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../database/app_database.dart';
import '../../../database/dao/mind_dao.dart';
import '../../../shared/models/drawing_models.dart';
import '../../../shared/models/thought_detail.dart';

class MindRepository {
  MindRepository(this._dao);

  final MindDao _dao;

  Future<(List<DrawingStroke>, Map<String, ThoughtDetail>)> loadCanvas() async {
    final strokeRows = await _dao.getAllStrokes();
    final detailRows = await _dao.getAllThoughtDetails();

    final strokes = strokeRows.map(_strokeFromRow).toList();
    final existingIds = strokes
        .where((s) => s.id != null)
        .map((s) => s.id!)
        .toSet();
    final details = {
      for (final r in detailRows)
        if (existingIds.contains(r.shapeId)) r.shapeId: _detailFromRow(r),
    };

    return (strokes, details);
  }

  Future<void> saveStrokes(List<DrawingStroke> strokes) =>
      _dao.replaceAllStrokes(strokes.map(_strokeToCompanion).toList());

  Future<void> upsertThoughtDetail(ThoughtDetail detail) =>
      _dao.upsertThoughtDetail(ThoughtDetailsCompanion.insert(
        shapeId: detail.shapeId,
        cause: Value(detail.cause),
        root: Value(detail.root),
        resolution: Value(detail.resolution),
      ));

  Future<void> clearAll() => _dao.deleteAllMindData();

  // --- serialization helpers ---

  DrawingStroke _strokeFromRow(DrawingStrokeRow row) {
    final raw = jsonDecode(row.pointsJson) as List<dynamic>;
    final points = raw
        .map((p) => Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()))
        .toList();
    return DrawingStroke(
      id: row.shapeId,
      title: row.title,
      points: points,
      color: Color(row.colorArgb),
      strokeWidth: row.strokeWidth,
      isEraser: row.isEraser,
      isClosed: row.isClosed,
    );
  }

  DrawingStrokesCompanion _strokeToCompanion(DrawingStroke stroke) {
    final pointsJson = jsonEncode(
      stroke.points.map((o) => [o.dx, o.dy]).toList(),
    );
    return DrawingStrokesCompanion.insert(
      shapeId: Value(stroke.id),
      title: Value(stroke.title),
      pointsJson: pointsJson,
      colorArgb: stroke.color.toARGB32(),
      strokeWidth: stroke.strokeWidth,
      isEraser: stroke.isEraser,
      isClosed: stroke.isClosed,
    );
  }

  ThoughtDetail _detailFromRow(ThoughtDetailRow row) => ThoughtDetail(
        shapeId: row.shapeId,
        cause: row.cause,
        root: row.root,
        resolution: row.resolution,
      );
}
