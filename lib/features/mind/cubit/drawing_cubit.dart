import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/drawing_models.dart';
import '../../../shared/models/thought_detail.dart';
import '../repository/mind_repository.dart';
import 'drawing_state.dart';

class DrawingCubit extends Cubit<DrawingState> {
  DrawingCubit(this._repository) : super(const DrawingState());

  final MindRepository _repository;

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
    final finalStroke = active.copyWith(points: finalPoints);
    final newStrokes = [...state.strokes, finalStroke];
    emit(state.copyWith(
      strokes: newStrokes,
      clearActiveStroke: true,
    ));
    _saveStrokes(newStrokes);
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
}
