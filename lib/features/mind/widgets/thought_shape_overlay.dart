import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/drawing_models.dart';
import '../../../shared/models/thought_detail.dart';
import 'drawing_painter.dart';

class ThoughtShapeOverlay extends StatelessWidget {
  const ThoughtShapeOverlay({
    super.key,
    required this.strokes,
    required this.thoughtDetails,
  });

  final List<DrawingStroke> strokes;
  final Map<String, ThoughtDetail> thoughtDetails;

  @override
  Widget build(BuildContext context) {
    final closedShapes = strokes
        .where((s) => s.isClosed && s.id != null)
        .toList();

    if (closedShapes.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: closedShapes.map((shape) {
        final center = _shapeCenter(shape);
        return Positioned(
          left: center.dx,
          top: center.dy,
          child: _TitleChip(
            shape: shape,
            onTap: () => context.push('/mind/thought/${shape.id}'),
          ),
        );
      }).toList(),
    );
  }

  Offset _shapeCenter(DrawingStroke stroke) {
    return buildStrokePath(stroke).getBounds().center;
  }
}

class _TitleChip extends StatelessWidget {
  const _TitleChip({required this.shape, required this.onTap});

  final DrawingStroke shape;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasTitle = shape.title != null && shape.title!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      // opaque so the tap recognizer enters the arena and beats the
      // canvas pan recognizer, preventing a stray dot from being drawn.
      behavior: HitTestBehavior.opaque,
      child: Transform.translate(
        // Center the chip on the anchor point.
        offset: const Offset(-40, -14),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: shape.color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shape.color.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!hasTitle)
                const Icon(Icons.add, color: Colors.white, size: 12),
              if (hasTitle) ...[
                Flexible(
                  child: Text(
                    shape.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white70, size: 9),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
