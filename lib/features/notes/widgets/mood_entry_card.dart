import 'package:flutter/material.dart';
import '../../../shared/models/mood_entry.dart';

class MoodEntryCard extends StatelessWidget {
  const MoodEntryCard({super.key, required this.entry});
  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(entry.description));
  }
}
