import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/graph_repository.dart';
import 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit(this._repository) : super(const GraphInitial());
  // ignore: unused_field
  final GraphRepository _repository;
}
