import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.description,
    required this.mood,
  });

  final int id;
  final DateTime timestamp;
  final String description;
  final int mood;

  MoodEntry copyWith({
    int? id,
    DateTime? timestamp,
    String? description,
    int? mood,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      mood: mood ?? this.mood,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, description, mood];
}
