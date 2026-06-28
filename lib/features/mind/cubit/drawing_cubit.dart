import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/drawing_models.dart';
import '../../../shared/models/thought_detail.dart';
import '../repository/mind_repository.dart';
import '../widgets/drawing_painter.dart';
import 'drawing_state.dart';

class DrawingCubit extends Cubit<DrawingState> {
  DrawingCubit(this._repository) : super(const DrawingState());

  final MindRepository _repository;

  // Fraction of a shape's area that must be rubbed over before the thought is
  // removed. Below this, the shape erodes gradually but its data survives.
  static const double _eraseThreshold = 0.6;

  Future<void> loadCanvas() async {
    final (strokes, details) = await _repository.loadCanvas();
    emit(state.copyWith(strokes: strokes, thoughtDetails: details));
  }

  void selectTool(DrawingTool tool) {
    emit(state.copyWith(selectedTool: tool));
  }

  void selectColor(DrawingColor color) {
    emit(state.copyWith(selectedColor: color));
  }

  void setStrokeWidth(double width) {
    emit(state.copyWith(strokeWidth: width));
  }

  void onPointerDown(Offset position) {
    if (state.selectedTool == DrawingTool.pencil) {
      _startPencilStroke(position);
    } else {
      _startEraserStroke(position);
    }
  }

  void onPointerMove(Offset position) {
    if (state.activeStroke == null) return;
    if (state.selectedTool == DrawingTool.pencil) {
      _continuePencilStroke(position);
    } else {
      _continueEraserStroke(position);
    }
  }

  void onPointerUp(Offset position) {
    if (state.activeStroke == null) return;
    if (state.selectedTool == DrawingTool.pencil) {
      _endPencilStroke(position);
    } else {
      _endEraserStroke(position);
    }
  }

  void _startPencilStroke(Offset position) {
    final stroke = DrawingStroke(
      points: [position],
      color: state.selectedColor.toColor(),
      strokeWidth: state.strokeWidth,
      isEraser: false,
    );
    emit(state.copyWith(activeStroke: stroke));
  }

  void _continuePencilStroke(Offset position) {
    final active = state.activeStroke!;
    final updatedPoints = [...active.points, position];
    emit(state.copyWith(
      activeStroke: active.copyWith(points: updatedPoints),
    ));
  }

  void _endPencilStroke(Offset position) {
    final active = state.activeStroke!;
    if (active.points.isEmpty) {
      emit(state.copyWith(clearActiveStroke: true));
      return;
    }

    final startPoint = active.points.first;
    final distance = _distance(position, startPoint);
    final isClosed = distance <= state.snapRadius;

    final finalPoints = isClosed
        ? [...active.points, startPoint]
        : [...active.points, position];

    if (isClosed) {
      final shapeId = DateTime.now().millisecondsSinceEpoch.toString();
      final finalStroke = active.copyWith(
        points: finalPoints,
        isClosed: true,
        id: shapeId,
      );
      final newStrokes = [...state.strokes, finalStroke];
      emit(state.copyWith(
        strokes: newStrokes,
        clearActiveStroke: true,
        pendingTitleShapeId: shapeId,
      ));
      _saveStrokes(newStrokes);
    } else {
      final finalStroke = active.copyWith(points: finalPoints);
      final newStrokes = [...state.strokes, finalStroke];
      emit(state.copyWith(
        strokes: newStrokes,
        clearActiveStroke: true,
      ));
      _saveStrokes(newStrokes);
    }
  }

  void _startEraserStroke(Offset position) {
    final stroke = DrawingStroke(
      points: [position],
      color: state.canvasColor.toColor(),
      strokeWidth: 28.0,
      isEraser: true,
    );
    emit(state.copyWith(activeStroke: stroke));
  }

  void _continueEraserStroke(Offset position) {
    final active = state.activeStroke!;
    final updatedPoints = [...active.points, position];
    emit(state.copyWith(
      activeStroke: active.copyWith(points: updatedPoints),
    ));
  }

  void _endEraserStroke(Offset position) {
    final active = state.activeStroke!;
    final finalPoints = [...active.points, position];
    final eraserStroke = active.copyWith(points: finalPoints);

    // A closed shape represents a thought. Rubbing the eraser over it erodes
    // it gradually (the eraser strokes paint white on top); the thought — and
    // its saved details — are only removed once it has been *substantially*
    // erased. This keeps the slow, deliberate "clearing the mind" feel instead
    // of wiping the whole thought away the instant the eraser grazes it.
    // Erosion can be spread across several separate touches, so coverage is
    // measured against accumulated eraser strokes. Crucially, only eraser
    // strokes drawn *after* a shape count toward erasing it — otherwise the
    // leftover eraser marks from a previously cleared thought would pre-erase
    // a new shape drawn in the same spot, wiping it out in one stroke.
    final erasedShapeIds = <String>{};
    for (int i = 0; i < state.strokes.length; i++) {
      final stroke = state.strokes[i];
      if (!stroke.isClosed || stroke.id == null) continue;
      final relevantErasers = <DrawingStroke>[
        for (int j = i + 1; j < state.strokes.length; j++)
          if (state.strokes[j].isEraser) state.strokes[j],
        eraserStroke,
      ];
      if (_shapeErasedFraction(stroke, relevantErasers) >= _eraseThreshold) {
        erasedShapeIds.add(stroke.id!);
      }
    }

    final remaining = erasedShapeIds.isEmpty
        ? state.strokes
        : state.strokes
            .where((s) => s.id == null || !erasedShapeIds.contains(s.id))
            .toList();
    final newStrokes = [...remaining, eraserStroke];

    if (erasedShapeIds.isEmpty) {
      emit(state.copyWith(strokes: newStrokes, clearActiveStroke: true));
      _saveStrokes(newStrokes);
      return;
    }

    final updatedDetails =
        Map<String, ThoughtDetail>.from(state.thoughtDetails)
          ..removeWhere((shapeId, _) => erasedShapeIds.contains(shapeId));
    emit(state.copyWith(
      strokes: newStrokes,
      thoughtDetails: updatedDetails,
      clearActiveStroke: true,
    ));
    _saveStrokes(newStrokes);
    _repository.deleteThoughtDetails(erasedShapeIds.toList()).ignore();
  }

  void setShapeTitle(String shapeId, String title) {
    final updatedStrokes = state.strokes.map((s) {
      if (s.id == shapeId) return s.copyWith(title: title);
      return s;
    }).toList();
    emit(state.copyWith(
      strokes: updatedStrokes,
      clearPendingTitleShapeId: true,
    ));
    _saveStrokes(updatedStrokes);
  }

  void clearPendingTitle() {
    emit(state.copyWith(clearPendingTitleShapeId: true));
  }

  void saveThoughtDetail(ThoughtDetail detail) {
    final updated = Map<String, ThoughtDetail>.from(state.thoughtDetails);
    updated[detail.shapeId] = detail;
    emit(state.copyWith(thoughtDetails: updated));
    _repository.upsertThoughtDetail(detail).ignore();
  }

  void undo() {
    if (state.strokes.isEmpty) return;
    final updated = List<DrawingStroke>.from(state.strokes)..removeLast();
    emit(state.copyWith(strokes: updated, clearActiveStroke: true));
    _saveStrokes(updated);
  }

  void clear() {
    emit(state.copyWith(strokes: [], clearActiveStroke: true));
    _repository.clearAll().ignore();
  }

  void _saveStrokes(List<DrawingStroke> strokes) {
    _repository.saveStrokes(strokes).ignore();
  }

  double _distance(Offset a, Offset b) {
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
  }

  /// Fraction (0–1) of [shape]'s interior covered by any of [eraserStrokes].
  /// Samples the shape's area on a grid and counts how many sample points
  /// fall within an eraser stroke's radius.
  double _shapeErasedFraction(
    DrawingStroke shape,
    List<DrawingStroke> eraserStrokes,
  ) {
    final path = buildStrokePath(shape);
    final bounds = path.getBounds();
    if (bounds.isEmpty) return 0;

    const step = 12.0;
    int total = 0;
    int covered = 0;
    for (double x = bounds.left; x <= bounds.right; x += step) {
      for (double y = bounds.top; y <= bounds.bottom; y += step) {
        final point = Offset(x, y);
        if (!path.contains(point)) continue;
        total++;
        if (_coveredByEraser(point, eraserStrokes)) covered++;
      }
    }
    return total == 0 ? 0 : covered / total;
  }

  bool _coveredByEraser(Offset point, List<DrawingStroke> eraserStrokes) {
    for (final eraser in eraserStrokes) {
      final radius = eraser.strokeWidth / 2;
      final pts = eraser.points;
      for (int i = 0; i < pts.length; i++) {
        if (_distance(point, pts[i]) <= radius) return true;
        if (i < pts.length - 1 &&
            _distanceToSegment(point, pts[i], pts[i + 1]) <= radius) {
          return true;
        }
      }
    }
    return false;
  }

  double _distanceToSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final lengthSq = ab.dx * ab.dx + ab.dy * ab.dy;
    if (lengthSq == 0) return _distance(p, a);
    final t =
        (((p.dx - a.dx) * ab.dx + (p.dy - a.dy) * ab.dy) / lengthSq)
            .clamp(0.0, 1.0);
    final projection = Offset(a.dx + ab.dx * t, a.dy + ab.dy * t);
    return _distance(p, projection);
  }
}
