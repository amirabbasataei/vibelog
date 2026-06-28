// lib/widgets/tool_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
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

        final cs = Theme.of(context).colorScheme;
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.15),
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
                      label: l10n.mindToolDraw,
                      isActive: state.selectedTool == DrawingTool.pencil,
                      onTap: () => cubit.selectTool(DrawingTool.pencil),
                    ),
                    const SizedBox(width: 8),
                    // Eraser button
                    _ToolButton(
                      icon: Icons.auto_fix_normal,
                      label: l10n.mindToolErase,
                      isActive: state.selectedTool == DrawingTool.eraser,
                      onTap: () => cubit.selectTool(DrawingTool.eraser),
                    ),
                    const SizedBox(width: 12),
                    // Divider
                    Container(width: 1, height: 36, color: cs.outlineVariant),
                    const SizedBox(width: 12),
                    // Stroke width label
                    Text(
                      l10n.mindToolSize,
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    // Stroke width slider
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: cs.primary,
                          thumbColor: cs.primary,
                          overlayColor: cs.primary.withValues(alpha: 0.2),
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
                    Container(width: 1, height: 36, color: cs.outlineVariant),
                    const SizedBox(width: 8),
                    // Undo
                    _IconAction(
                      icon: Icons.undo,
                      tooltip: l10n.undo,
                      onTap: cubit.undo,
                    ),
                    const SizedBox(width: 4),
                    // Clear
                    _IconAction(
                      icon: Icons.delete_outline,
                      tooltip: l10n.mindClearTooltip,
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
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mindClearTitle),
        content: Text(l10n.mindClearBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.mindClearConfirm,
                style: TextStyle(color: cs.error)),
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
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? cs.primary : cs.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isActive ? cs.onPrimary : cs.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
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
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Icon(icon, size: 18, color: cs.onSurfaceVariant),
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
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.outlineVariant,
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
