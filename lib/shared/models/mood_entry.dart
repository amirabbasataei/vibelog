import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.description,
    required this.mood,
    required this.energy,
    required this.boredom,
  });

  final int id;
  final DateTime timestamp;
  final String description;
  final int mood;
  final int energy;
  final int boredom;

  MoodEntry copyWith({
    int? id,
    DateTime? timestamp,
    String? description,
    int? mood,
    int? energy,
    int? boredom,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      boredom: boredom ?? this.boredom,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, description, mood, energy, boredom];
}
