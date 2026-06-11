import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/drawing_cubit.dart';
import '../cubit/drawing_state.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  // Saved on onPanDown so onPanStart can use the exact touch origin,
  // even though the pan recognizer accepts only after the slop threshold.
  Offset _touchStart = Offset.zero;
  Offset _lastPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingCubit, DrawingState>(
      builder: (context, state) {
        final cubit = context.read<DrawingCubit>();
        final bgColor = state.canvasColor.toColor();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          // onPanDown fires on pointer-down before the arena resolves,
          // so we can capture the exact start position.
          onPanDown: (d) {
            _touchStart = d.localPosition;
            _lastPosition = d.localPosition;
          },
          // Drag path — pan recognizer wins when movement exceeds slop.
          onPanStart: (_) => cubit.onPointerDown(_touchStart),
          onPanUpdate: (d) {
            _lastPosition = d.localPosition;
            cubit.onPointerMove(d.localPosition);
          },
          onPanEnd: (_) => cubit.onPointerUp(_lastPosition),
          // Tap path — tap recognizer wins for a press-and-release.
          // Creates a single dot at the touch point.
          onTapUp: (d) {
            cubit.onPointerDown(d.localPosition);
            cubit.onPointerUp(d.localPosition);
          },
          child: Container(
            color: bgColor,
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: state.strokes,
                activeStroke: state.activeStroke,
                canvasColor: bgColor,
                snapRadius: state.snapRadius,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }
}
