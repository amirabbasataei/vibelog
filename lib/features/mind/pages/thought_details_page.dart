import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/thought_detail.dart';
import '../cubit/drawing_cubit.dart';
import '../cubit/drawing_state.dart';

class ThoughtDetailsPage extends StatefulWidget {
  const ThoughtDetailsPage({super.key, required this.shapeId});

  final String shapeId;

  @override
  State<ThoughtDetailsPage> createState() => _ThoughtDetailsPageState();
}

class _ThoughtDetailsPageState extends State<ThoughtDetailsPage> {
  late final TextEditingController _causeCtrl;
  late final TextEditingController _rootCtrl;
  late final TextEditingController _resolutionCtrl;
  late final DrawingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DrawingCubit>();
    final state = _cubit.state;
    final detail = state.thoughtDetails[widget.shapeId];
    _causeCtrl = TextEditingController(text: detail?.cause ?? '');
    _rootCtrl = TextEditingController(text: detail?.root ?? '');
    _resolutionCtrl = TextEditingController(text: detail?.resolution ?? '');
  }

  @override
  void dispose() {
    _causeCtrl.dispose();
    _rootCtrl.dispose();
    _resolutionCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final detail = ThoughtDetail(
      shapeId: widget.shapeId,
      cause: _causeCtrl.text.trim(),
      root: _rootCtrl.text.trim(),
      resolution: _resolutionCtrl.text.trim(),
    );
    _cubit.saveThoughtDetail(detail);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<DrawingCubit, DrawingState>(
      builder: (context, state) {
        final shape =
            state.strokes.where((s) => s.id == widget.shapeId).firstOrNull;
        final titleText = (shape?.title?.isNotEmpty ?? false)
            ? shape!.title!
            : l10n.thoughtNoTitle;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.thoughtDetailsTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ThoughtTitleChip(title: titleText, shapeColor: shape?.color),
                const SizedBox(height: 24),
                _DetailSection(
                  label: l10n.thoughtCauseLabel,
                  hint: l10n.thoughtCauseHint,
                  controller: _causeCtrl,
                  icon: Icons.bolt_outlined,
                  iconColor: colorScheme.error,
                ),
                const SizedBox(height: 20),
                _DetailSection(
                  label: l10n.thoughtRootLabel,
                  hint: l10n.thoughtRootHint,
                  controller: _rootCtrl,
                  icon: Icons.account_tree_outlined,
                  iconColor: colorScheme.tertiary,
                ),
                const SizedBox(height: 20),
                _DetailSection(
                  label: l10n.thoughtResolutionLabel,
                  hint: l10n.thoughtResolutionHint,
                  controller: _resolutionCtrl,
                  icon: Icons.lightbulb_outline,
                  iconColor: colorScheme.primary,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(l10n.thoughtSaveDetails),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThoughtTitleChip extends StatelessWidget {
  const _ThoughtTitleChip({required this.title, this.shapeColor});
  final String title;
  final Color? shapeColor;

  @override
  Widget build(BuildContext context) {
    final color = shapeColor ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bubble_chart_outlined, color: color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          minLines: 3,
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
