import 'package:equatable/equatable.dart';
import '../../../shared/models/mood_entry.dart';

sealed class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {
  const NotesInitial();
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesLoaded extends NotesState {
  const NotesLoaded(this.entries);
  final List<MoodEntry> entries;
  @override
  List<Object?> get props => [entries];
}

class NotesError extends NotesState {
  const NotesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
