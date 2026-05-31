import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/mood_entry.dart';
import '../repository/notes_repository.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._repository) : super(const NotesInitial());
  final NotesRepository _repository;
  StreamSubscription<List<MoodEntry>>? _sub;

  void watchEntries() {
    emit(const NotesLoading());
    _sub = _repository.watchAll().listen(
      (entries) => emit(NotesLoaded(entries)),
      onError: (e) => emit(NotesError(e.toString())),
    );
  }

  Future<void> addEntry(MoodEntry entry) => _repository.add(entry);
  Future<void> updateEntry(MoodEntry entry) => _repository.update(entry);
  Future<void> deleteEntry(int id) => _repository.delete(id);
  Future<MoodEntry?> getEntry(int id) => _repository.getById(id);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
