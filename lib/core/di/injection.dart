import 'package:get_it/get_it.dart';
import '../../database/app_database.dart';
import '../../database/dao/mood_entries_dao.dart';
import '../../features/notes/repository/notes_repository.dart';
import '../../features/notes/cubit/notes_cubit.dart';
import '../../features/graph/repository/graph_repository.dart';
import '../../features/graph/cubit/graph_cubit.dart';
import '../../features/settings/cubit/settings_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<MoodEntriesDao>(
    MoodEntriesDao(getIt<AppDatabase>()),
  );

  getIt.registerSingleton<NotesRepository>(
    NotesRepository(getIt<MoodEntriesDao>()),
  );
  getIt.registerSingleton<GraphRepository>(
    GraphRepository(getIt<MoodEntriesDao>()),
  );

  getIt.registerFactory<NotesCubit>(
    () => NotesCubit(getIt<NotesRepository>()),
  );
  getIt.registerFactory<GraphCubit>(
    () => GraphCubit(getIt<GraphRepository>()),
  );

  final settingsCubit = SettingsCubit();
  await settingsCubit.loadSettings();
  getIt.registerSingleton<SettingsCubit>(settingsCubit);
}
