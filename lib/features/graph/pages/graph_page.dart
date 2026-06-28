import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/settings/cubit/settings_cubit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/mood_entry.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../cubit/graph_cubit.dart';
import '../cubit/graph_state.dart';
import '../widgets/score_line_chart.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GraphCubit>()..loadEntries(),
      child: const _GraphBody(),
    );
  }
}

class _GraphBody extends StatelessWidget {
  const _GraphBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final maxY = context.watch<SettingsCubit>().state.scaleMax.toDouble();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GraphCubit, GraphState>(
          builder: (context, state) {
            final activeFilter = state is GraphLoaded ? state.filter : GraphFilter.thirtyDays;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.graphInsights,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      _FilterRow(activeFilter: activeFilter),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state) {
                    GraphInitial() || GraphLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    GraphError(:final message) => _ErrorView(message: message),
                    GraphLoaded(:final entries) => entries.length < 2
                        ? EmptyStateWidget(
                            message: l10n.emptyGraph,
                            icon: Icons.show_chart,
                          )
                        : _ChartsView(entries: entries, maxY: maxY),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.activeFilter});
  final GraphFilter activeFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<GraphCubit>();
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cs.outline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilterChip(
            label: l10n.graph7d,
            active: activeFilter == GraphFilter.sevenDays,
            onTap: () => cubit.setFilter(GraphFilter.sevenDays),
          ),
          _FilterChip(
            label: l10n.graph30d,
            active: activeFilter == GraphFilter.thirtyDays,
            onTap: () => cubit.setFilter(GraphFilter.thirtyDays),
          ),
          _FilterChip(
            label: l10n.graphAll,
            active: activeFilter == GraphFilter.all,
            onTap: () => cubit.setFilter(GraphFilter.all),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? moodColor : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : cs.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.read<GraphCubit>().loadEntries(),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _ChartsView extends StatelessWidget {
  const _ChartsView({required this.entries, required this.maxY});
  final List<MoodEntry> entries;
  final double maxY;

  List<FlSpot> _toSpots(int Function(MoodEntry) score) => entries
      .map((e) => FlSpot(
            e.timestamp.millisecondsSinceEpoch.toDouble(),
            score(e).toDouble(),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = context.watch<SettingsCubit>().state.locale;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: SizedBox(
        height: 260,
        child: ScoreLineChart(
          title: l10n.mood,
          spots: _toSpots((e) => e.mood),
          color: moodColor,
          maxY: maxY,
          locale: locale,
        ),
      ),
    );
  }
}
