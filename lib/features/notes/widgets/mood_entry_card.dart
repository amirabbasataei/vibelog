import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/mood_entry.dart';

class MoodEntryCard extends StatelessWidget {
  const MoodEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDismissed,
  });

  final MoodEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final timeStr = DateFormat('HH:mm').format(entry.timestamp);

    return Dismissible(
      key: Key('entry_${entry.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 24),
        decoration: BoxDecoration(
          color: cs.error,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outline, width: 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              timeStr,
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              _moodEmoji(entry.mood),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          entry.description.isEmpty
                              ? l10n.descriptionHint
                              : entry.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: entry.description.isEmpty
                                ? cs.onSurfaceVariant
                                : cs.onSurface,
                            fontSize: 13.5,
                            height: 1.48,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            _ScoreChip(
                              value: entry.mood,
                              color: moodColor,
                              dimColor: moodDim,
                            ),
                            // const SizedBox(width: 5),
                            // _ScoreChip(
                            //   value: entry.energy,
                            //   color: energyColor,
                            //   dimColor: energyDim,
                            // ),
                            // const SizedBox(width: 5),
                            // _ScoreChip(
                            //   value: entry.boredom,
                            //   color: boredomColor,
                            //   dimColor: boredomDim,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _moodEmoji(int mood) {
    if (mood >= 8) return '😊';
    if (mood >= 5) return '😐';
    return '😔';
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({
    required this.value,
    required this.color,
    required this.dimColor,
  });

  final int value;
  final Color color;
  final Color dimColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: dimColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
