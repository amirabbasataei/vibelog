import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/mood_entry.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../widgets/mood_entry_card.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotesCubit>()..watchEntries(),
      child: const _NotesBody(),
    );
  }
}

class _NotesBody extends StatelessWidget {
  const _NotesBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) => switch (state) {
            NotesInitial() || NotesLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            NotesError(:final message) => _ErrorView(message: message),
            NotesLoaded(:final entries) => _LoadedView(entries: entries),
          },
        ),
      ),
      floatingActionButton: _buildFab(context, l10n),
    );
  }

  Widget _buildFab(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [moodColor, Color(0xFF7C5CF5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x807C5CF5),
              blurRadius: 28,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.push('/notes/add'),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
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
          Text(message,
              style: TextStyle(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.read<NotesCubit>().watchEntries(),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.entries});
  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = _groupByDate(entries, l10n);
    final streak = _computeStreak(entries);
    final todayAvg = _todayAvg(entries);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NotesHeader(streak: streak, entryCount: entries.length),
        if (todayAvg != null) _TodayAvgBar(avg: todayAvg),
        Expanded(
          child: entries.isEmpty
              ? EmptyStateWidget(
                  message: l10n.emptyNotes,
                  icon: Icons.book_outlined,
                )
              : _EntryList(groups: groups),
        ),
      ],
    );
  }

  List<(String, List<MoodEntry>)> _groupByDate(
      List<MoodEntry> entries, AppLocalizations l10n) {
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final groups = <String, List<MoodEntry>>{};
    final order = <String>[];

    for (final e in entries) {
      final day = DateUtils.dateOnly(e.timestamp);
      final String label;
      if (day == today) {
        label = l10n.today.toUpperCase();
      } else if (day == yesterday) {
        label = l10n.yesterday.toUpperCase();
      } else {
        label = DateFormat('MMMM d, y').format(day).toUpperCase();
      }
      if (!groups.containsKey(label)) {
        groups[label] = [];
        order.add(label);
      }
      groups[label]!.add(e);
    }
    return order.map((k) => (k, groups[k]!)).toList();
  }

  int _computeStreak(List<MoodEntry> entries) {
    if (entries.isEmpty) return 0;
    final today = DateUtils.dateOnly(DateTime.now());
    final days = entries
        .map((e) => DateUtils.dateOnly(e.timestamp))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime check = today;
    for (final day in days) {
      if (day == check) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else if (day.isBefore(check)) {
        break;
      }
    }
    return streak;
  }

  Map<String, double>? _todayAvg(List<MoodEntry> entries) {
    final today = DateUtils.dateOnly(DateTime.now());
    final todayEntries = entries
        .where((e) => DateUtils.dateOnly(e.timestamp) == today)
        .toList();
    if (todayEntries.isEmpty) return null;
    final count = todayEntries.length;
    return {
      'mood': todayEntries.fold(0, (s, e) => s + e.mood) / count,
      'energy': todayEntries.fold(0, (s, e) => s + e.energy) / count,
      'boredom': todayEntries.fold(0, (s, e) => s + e.boredom) / count,
    };
  }
}

class _NotesHeader extends StatelessWidget {
  const _NotesHeader({required this.streak, required this.entryCount});
  final int streak;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [moodColor, Color(0xFFF472B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: Colors.white,
                  ),
                ),
              ),
              // Container(
              //   width: 36,
              //   height: 36,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [moodColor, Color(0xFF7C5CF5)],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Center(
              //     child: Text(
              //       'A',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 14,
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
          child: Row(
            children: [
              _StatPill(
                icon: '🔥',
                label: '$streak ${l10n.dayStreakLabel}',
                cs: cs,
              ),
              const SizedBox(width: 10),
              _StatPill(
                icon: '📝',
                label: '$entryCount ${l10n.entriesLabel}',
                cs: cs,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.cs,
  });
  final String icon;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 14, 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cs.outline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayAvgBar extends StatelessWidget {
  const _TodayAvgBar({required this.avg});
  final Map<String, double> avg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outline, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.todayAvgLabel.toUpperCase(),
              style: TextStyle(
                color: cs.onSurfaceVariant.withAlpha(100),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Row(
            children: [
              _AvgScore(
                value: avg['mood']!,
                label: l10n.mood,
                color: moodColor,
              ),
              const SizedBox(width: 18),
              _AvgScore(
                value: avg['energy']!,
                label: l10n.energy,
                color: energyColor,
              ),
              const SizedBox(width: 18),
              _AvgScore(
                value: avg['boredom']!,
                label: l10n.boredom,
                color: boredomColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvgScore extends StatelessWidget {
  const _AvgScore({
    required this.value,
    required this.label,
    required this.color,
  });
  final double value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            color: cs.onSurfaceVariant.withAlpha(120),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({required this.groups});
  final List<(String, List<MoodEntry>)> groups;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: _itemCount(),
      itemBuilder: (context, index) => _buildItem(context, index),
    );
  }

  int _itemCount() {
    int count = 0;
    for (final (_, entries) in groups) {
      count += 1 + entries.length; // separator + cards
    }
    return count;
  }

  Widget _buildItem(BuildContext context, int index) {
    int cursor = 0;
    for (final (label, entries) in groups) {
      if (index == cursor) return _DateSeparator(label: label);
      cursor++;
      for (final entry in entries) {
        if (index == cursor) return _EntryCardWrapper(entry: entry);
        cursor++;
      }
    }
    return const SizedBox.shrink();
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
      child: Text(
        label,
        style: TextStyle(
          color: cs.onSurfaceVariant.withAlpha(100),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _EntryCardWrapper extends StatelessWidget {
  const _EntryCardWrapper({required this.entry});
  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<NotesCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: MoodEntryCard(
        entry: entry,
        onTap: () => context.push('/notes/edit/${entry.id}'),
        onDismissed: () {
          cubit.deleteEntry(entry.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.entryDeleted),
              action: SnackBarAction(
                label: l10n.undo,
                onPressed: () => cubit.addEntry(entry),
              ),
            ),
          );
        },
      ),
    );
  }
}
