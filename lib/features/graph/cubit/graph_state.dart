import 'package:equatable/equatable.dart';
import '../../../shared/models/mood_entry.dart';

enum GraphFilter { sevenDays, thirtyDays, all }

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
  const GraphLoaded(this.entries, this.filter);
  final List<MoodEntry> entries;
  final GraphFilter filter;
  @override
  List<Object?> get props => [entries, filter];
}

class GraphError extends GraphState {
  const GraphError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
