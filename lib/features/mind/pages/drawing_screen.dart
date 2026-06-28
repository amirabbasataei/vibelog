import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/models/drawing_models.dart';
import '../cubit/drawing_cubit.dart';
import '../cubit/drawing_state.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/tool_bar.dart';

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: BlocConsumer<DrawingCubit, DrawingState>(
        listenWhen: (prev, curr) =>
            curr.pendingTitleShapeId != null &&
            prev.pendingTitleShapeId != curr.pendingTitleShapeId,
        listener: (context, state) {
          _showTitleDialog(
            context,
            context.read<DrawingCubit>(),
            state.pendingTitleShapeId!,
            l10n,
          );
        },
        builder: (context, state) {
          return Column(
            children: [
              const ToolBar(),
              _StatusBar(state: state),
              const Expanded(
                child: Stack(
                  children: [
                    DrawingCanvas(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _showTitleDialog(
    BuildContext context,
    DrawingCubit cubit,
    String shapeId,
    AppLocalizations l10n,
  ) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _TitleDialog(l10n: l10n),
    );
    if (result != null && result.isNotEmpty) {
      cubit.setShapeTitle(shapeId, result);
    } else {
      cubit.clearPendingTitle();
    }
  }
}

class _StatusBar extends StatelessWidget {
  final DrawingState state;
  const _StatusBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDrawing = state.activeStroke != null;
    final isPencil = state.selectedTool == DrawingTool.pencil;

    String message;
    if (!isDrawing) {
      message = isPencil
          ? 'Tap & drag to draw • Return near the start point to close the shape'
          : 'Tap & drag to erase gradually';
    } else if (isPencil) {
      final pts = state.activeStroke!.points;
      message = pts.length < 3
          ? 'Drawing… keep going'
          : 'Return close to the start ● to close & fill the shape';
    } else {
      message = 'Erasing…';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      color: isDrawing
          ? const Color(0xFF457B9D).withValues(alpha: 0.1)
          : const Color(0xFFF0F0F0),
      child: Row(
        children: [
          Icon(
            isPencil ? Icons.edit : Icons.auto_fix_normal,
            size: 13,
            color: const Color(0xFF457B9D),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF555577),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (state.strokes.isNotEmpty)
            Text(
              '${state.strokes.length} stroke${state.strokes.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF888899),
              ),
            ),
        ],
      ),
    );
  }
}

class _TitleDialog extends StatefulWidget {
  const _TitleDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_TitleDialog> createState() => _TitleDialogState();
}

class _TitleDialogState extends State<_TitleDialog>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Dialog(
          backgroundColor: cs.surfaceContainer,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: cs.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge + title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.psychology_outlined,
                        color: cs.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.l10n.thoughtNameDialogTitle,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.l10n.thoughtNameHint,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                // Input field
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 15,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.l10n.thoughtNameHint,
                    prefixIcon: Icon(
                      Icons.label_outline_rounded,
                      color: cs.primary.withValues(alpha: 0.7),
                      size: 19,
                    ),
                  ),
                  onSubmitted: (v) => Navigator.pop(context, v.trim()),
                ),
                const SizedBox(height: 28),
                // Action buttons
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: cs.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        widget.l10n.thoughtSkip,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: _controller,
                        builder: (context, _) {
                          final hasText = _controller.text.trim().isNotEmpty;
                          return FilledButton(
                            onPressed: hasText
                                ? () => Navigator.pop(
                                      context,
                                      _controller.text.trim(),
                                    )
                                : null,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              widget.l10n.save,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
