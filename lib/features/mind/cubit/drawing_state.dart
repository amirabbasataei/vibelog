import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/drawing_models.dart';
import '../../../shared/models/thought_detail.dart';

class DrawingState extends Equatable {
  final List<DrawingStroke> strokes;
  final DrawingStroke? activeStroke;
  final DrawingTool selectedTool;
  final DrawingColor selectedColor;
  final double strokeWidth;
  final DrawingColor canvasColor;
  final double snapRadius;
  final Map<String, ThoughtDetail> thoughtDetails;
  final String? pendingTitleShapeId;

  const DrawingState({
    this.strokes = const [],
    this.activeStroke,
    this.selectedTool = DrawingTool.pencil,
    this.selectedColor = DrawingColor.black,
    this.strokeWidth = 3.0,
    this.canvasColor = DrawingColor.white,
    this.snapRadius = 20.0,
    this.thoughtDetails = const {},
    this.pendingTitleShapeId,
  });

  bool get isDrawing => activeStroke != null;

  DrawingState copyWith({
    List<DrawingStroke>? strokes,
    DrawingStroke? activeStroke,
    bool clearActiveStroke = false,
    DrawingTool? selectedTool,
    DrawingColor? selectedColor,
    double? strokeWidth,
    DrawingColor? canvasColor,
    double? snapRadius,
    Map<String, ThoughtDetail>? thoughtDetails,
    String? pendingTitleShapeId,
    bool clearPendingTitleShapeId = false,
  }) {
    return DrawingState(
      strokes: strokes ?? this.strokes,
      activeStroke:
          clearActiveStroke ? null : activeStroke ?? this.activeStroke,
      selectedTool: selectedTool ?? this.selectedTool,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      canvasColor: canvasColor ?? this.canvasColor,
      snapRadius: snapRadius ?? this.snapRadius,
      thoughtDetails: thoughtDetails ?? this.thoughtDetails,
      pendingTitleShapeId: clearPendingTitleShapeId
          ? null
          : pendingTitleShapeId ?? this.pendingTitleShapeId,
    );
  }

  @override
  List<Object?> get props => [
        strokes,
        activeStroke,
        selectedTool,
        selectedColor,
        strokeWidth,
        canvasColor,
        snapRadius,
        thoughtDetails,
        pendingTitleShapeId,
      ];
}

enum DrawingColor {
  black,
  white,
  red,
  blue,
  green,
  yellow,
  orange,
  purple,
}

extension DrawingColorExt on DrawingColor {
  Color toColor() {
    switch (this) {
      case DrawingColor.black:
        return const Color(0xFF1A1A2E);
      case DrawingColor.white:
        return const Color(0xFFF8F8F8);
      case DrawingColor.red:
        return const Color(0xFFE63946);
      case DrawingColor.blue:
        return const Color(0xFF457B9D);
      case DrawingColor.green:
        return const Color(0xFF2D6A4F);
      case DrawingColor.yellow:
        return const Color(0xFFFFB703);
      case DrawingColor.orange:
        return const Color(0xFFF4A261);
      case DrawingColor.purple:
        return const Color(0xFF7B2D8B);
    }
  }

  String get label {
    switch (this) {
      case DrawingColor.black:
        return 'Black';
      case DrawingColor.white:
        return 'White';
      case DrawingColor.red:
        return 'Red';
      case DrawingColor.blue:
        return 'Blue';
      case DrawingColor.green:
        return 'Green';
      case DrawingColor.yellow:
        return 'Yellow';
      case DrawingColor.orange:
        return 'Orange';
      case DrawingColor.purple:
        return 'Purple';
    }
  }
}
