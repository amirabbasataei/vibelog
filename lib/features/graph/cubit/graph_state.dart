import 'package:equatable/equatable.dart';
import '../../../shared/models/mood_entry.dart';

sealed class GraphState extends Equatable {
  const GraphState();
  @override
  List<Object?> get props => [];
}

class GraphInitial extends GraphState {
  const GraphInitial();
}

class GraphLoading extends GraphState {
  const GraphLoading();
}

class GraphLoaded extends GraphState {
  const GraphLoaded(this.entries);
  final List<MoodEntry> entries;
  @override
  List<Object?> get props => [entries];
}

class GraphError extends GraphState {
  const GraphError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
