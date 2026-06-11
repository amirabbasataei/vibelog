// lib/widgets/tool_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/drawing_models.dart';
import '../cubit/drawing_cubit.dart';
import '../cubit/drawing_state.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingCubit, DrawingState>(
      builder: (context, state) {
        final cubit = context.read<DrawingCubit>();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Row 1: Tool toggle + stroke width + actions ──
                Row(
                  children: [
                    // Pencil button
                    _ToolButton(
                      icon: Icons.edit,
                      label: 'Draw',
                      isActive: state.selectedTool == DrawingTool.pencil,
                      onTap: () => cubit.selectTool(DrawingTool.pencil),
                    ),
                    const SizedBox(width: 8),
                    // Eraser button
                    _ToolButton(
                      icon: Icons.auto_fix_normal,
                      label: 'Erase',
                      isActive: state.selectedTool == DrawingTool.eraser,
                      onTap: () => cubit.selectTool(DrawingTool.eraser),
                    ),
                    const SizedBox(width: 12),
                    // Divider
                    Container(width: 1, height: 36, color: Colors.white24),
                    const SizedBox(width: 12),
                    // Stroke width label
                    const Text(
                      'Size',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    // Stroke width slider
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF457B9D),
                          thumbColor: Colors.white,
                          overlayColor:
                              const Color(0xFF457B9D).withValues(alpha: 0.2),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                        ),
                        child: Slider(
                          value: state.strokeWidth,
                          min: 1.0,
                          max: 16.0,
                          onChanged: (v) => cubit.setStrokeWidth(v),
                        ),
                      ),
                    ),
                    // Stroke preview circle
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      child: Container(
                        width: state.strokeWidth.clamp(2.0, 22.0),
                        height: state.strokeWidth.clamp(2.0, 22.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: state.selectedColor.toColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 1, height: 36, color: Colors.white24),
                    const SizedBox(width: 8),
                    // Undo
                    _IconAction(
                      icon: Icons.undo,
                      tooltip: 'Undo',
                      onTap: cubit.undo,
                    ),
                    const SizedBox(width: 4),
                    // Clear
                    _IconAction(
                      icon: Icons.delete_outline,
                      tooltip: 'Clear all',
                      onTap: () => _confirmClear(context, cubit),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // ── Row 2: Color palette ──
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: DrawingColor.values
                        .where((c) => c != DrawingColor.white) // skip bg color
                        .map((c) => _ColorSwatch(
                              color: c,
                              isSelected: state.selectedColor == c,
                              onTap: () {
                                cubit.selectColor(c);
                                if (state.selectedTool == DrawingTool.eraser) {
                                  cubit.selectTool(DrawingTool.pencil);
                                }
                              },
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmClear(BuildContext context, DrawingCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Clear canvas',
            style: TextStyle(color: Colors.white)),
        content: const Text('Remove all strokes?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Clear', style: TextStyle(color: Color(0xFFE63946))),
          ),
        ],
      ),
    );
    if (confirmed == true) cubit.clear();
  }
}

// ── Small tool toggle button ──────────────────────────────────────────────────

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF457B9D)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? const Color(0xFF457B9D)
                : Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isActive ? Colors.white : Colors.white54),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.white : Colors.white54,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Icon-only action button ───────────────────────────────────────────────────

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.15), width: 1),
          ),
          child: Icon(icon, size: 18, color: Colors.white70),
        ),
      ),
    );
  }
}

// ── Color swatch ─────────────────────────────────────────────────────────────

class _ColorSwatch extends StatelessWidget {
  final DrawingColor color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isSelected ? 32 : 28,
          height: isSelected ? 32 : 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.toColor(),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white24,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.toColor().withValues(alpha: 0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
