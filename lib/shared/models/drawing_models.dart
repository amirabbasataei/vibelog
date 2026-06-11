import 'package:flutter/material.dart';

enum DrawingTool { pencil, eraser }

class DrawingStroke {
  final String? id;
  final String? title;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;
  final bool isClosed;

  const DrawingStroke({
    this.id,
    this.title,
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.isEraser,
    this.isClosed = false,
  });

  DrawingStroke copyWith({
    String? id,
    String? title,
    List<Offset>? points,
    Color? color,
    double? strokeWidth,
    bool? isEraser,
    bool? isClosed,
  }) {
    return DrawingStroke(
      id: id ?? this.id,
      title: title ?? this.title,
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isEraser: isEraser ?? this.isEraser,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
