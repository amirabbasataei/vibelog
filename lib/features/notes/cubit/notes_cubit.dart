import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/notes_repository.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._repository) : super(const NotesInitial());
  // ignore: unused_field
  final NotesRepository _repository;
}
