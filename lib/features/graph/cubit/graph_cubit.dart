import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/mood_entry.dart';
import '../repository/graph_repository.dart';
import 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit(this._repository) : super(const GraphInitial());
  final GraphRepository _repository;
  List<MoodEntry> _all = [];

  Future<void> loadEntries() async {
    emit(const GraphLoading());
    try {
      _all = await _repository.getAllEntries();
      emit(GraphLoaded(_applyFilter(_all, GraphFilter.thirtyDays), GraphFilter.thirtyDays));
    } catch (e) {
      emit(GraphError(e.toString()));
    }
  }

  void setFilter(GraphFilter filter) {
    if (state is GraphLoaded) {
      emit(GraphLoaded(_applyFilter(_all, filter), filter));
    }
  }

  List<MoodEntry> _applyFilter(List<MoodEntry> entries, GraphFilter filter) {
    if (filter == GraphFilter.all) return List.from(entries);
    final days = filter == GraphFilter.sevenDays ? 7 : 30;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return entries.where((e) => e.timestamp.isAfter(cutoff)).toList();
  }
}
