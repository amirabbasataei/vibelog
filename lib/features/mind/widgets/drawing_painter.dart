import 'dart:math';
import 'package:flutter/material.dart';

import '../../../shared/models/drawing_models.dart';

/// Builds the bezier path for a stroke (shared with overlay centroid logic).
Path buildStrokePath(DrawingStroke stroke) {
  final path = Path();
  final pts = stroke.points;
  if (pts.isEmpty) return path;

  path.moveTo(pts.first.dx, pts.first.dy);

  if (pts.length == 2) {
    path.lineTo(pts[1].dx, pts[1].dy);
  } else {
    for (int i = 1; i < pts.length - 1; i++) {
      final mid = Offset(
        (pts[i].dx + pts[i + 1].dx) / 2,
        (pts[i].dy + pts[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
  }

  if (stroke.isClosed) path.close();
  return path;
}

class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? activeStroke;
  final Color canvasColor;
  final double snapRadius;

  const DrawingPainter({
    required this.strokes,
    required this.activeStroke,
    required this.canvasColor,
    required this.snapRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _paintStroke(canvas, stroke);
    }
    if (activeStroke != null) {
      _paintStroke(canvas, activeStroke!);
      _paintSnapIndicator(canvas, activeStroke!);
    }
  }

  void _paintStroke(Canvas canvas, DrawingStroke stroke) {
    if (stroke.points.length < 2) {
      if (stroke.points.isNotEmpty) {
        final paint = _buildPaint(stroke)..style = PaintingStyle.fill;
        canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, paint);
      }
      return;
    }

    if (stroke.isEraser) {
      _paintEraserDots(canvas, stroke);
    } else {
      _paintPencilPath(canvas, stroke);
      if (stroke.isClosed && stroke.title != null && stroke.title!.isNotEmpty) {
        _paintShapeTitle(canvas, stroke);
      }
    }
  }

  void _paintPencilPath(Canvas canvas, DrawingStroke stroke) {
    final paint = _buildPaint(stroke);
    final path = buildStrokePath(stroke);
    canvas.drawPath(path, paint);

    if (stroke.isClosed) {
      final fillPaint = Paint()
        ..color = stroke.color.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }
  }

  void _paintShapeTitle(Canvas canvas, DrawingStroke stroke) {
    final path = buildStrokePath(stroke);
    final bounds = path.getBounds();
    if (bounds.width < 16 || bounds.height < 16) return;

    canvas.save();
    canvas.clipPath(path);

    final textPainter = TextPainter(
      text: TextSpan(
        text: stroke.title,
        style: TextStyle(
          color: stroke.color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final maxWidth = (bounds.width - 20).clamp(1.0, double.infinity);
    textPainter.layout(maxWidth: maxWidth);

    final textOffset = bounds.center -
        Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);

    canvas.restore();
  }

  void _paintEraserDots(Canvas canvas, DrawingStroke stroke) {
    final paint = Paint()
      ..color = canvasColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final radius = stroke.strokeWidth / 2;
    for (final pt in stroke.points) {
      canvas.drawCircle(pt, radius, paint);
    }

    final pts = stroke.points;
    for (int i = 0; i < pts.length - 1; i++) {
      final a = pts[i];
      final b = pts[i + 1];
      final dist = _dist(a, b);
      final steps = (dist / (radius * 0.5)).ceil();
      for (int s = 1; s < steps; s++) {
        final t = s / steps;
        final interp = Offset(
          a.dx + (b.dx - a.dx) * t,
          a.dy + (b.dy - a.dy) * t,
        );
        canvas.drawCircle(interp, radius, paint);
      }
    }
  }

  void _paintSnapIndicator(Canvas canvas, DrawingStroke stroke) {
    if (stroke.isEraser || stroke.points.length < 3) return;

    final start = stroke.points.first;
    final current = stroke.points.last;
    final dist = _dist(current, start);

    if (dist > snapRadius * 3) return;

    final opacity = 1.0 - (dist / (snapRadius * 3)).clamp(0.0, 1.0);
    final ringPaint = Paint()
      ..color = stroke.color.withValues(alpha: opacity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(start, snapRadius, ringPaint);

    final dotPaint = Paint()
      ..color = stroke.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(start, 4, dotPaint);
  }

  Paint _buildPaint(DrawingStroke stroke) {
    return Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
  }

  double _dist(Offset a, Offset b) =>
      sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) =>
      oldDelegate.strokes != strokes ||
      oldDelegate.activeStroke != activeStroke ||
      oldDelegate.canvasColor != canvasColor;
}
