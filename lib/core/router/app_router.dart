import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_shell.dart';
import '../../features/notes/pages/notes_page.dart';
import '../../features/notes/pages/add_edit_entry_page.dart';
import '../../features/graph/pages/graph_page.dart';
import '../../features/settings/pages/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/notes',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/notes',
          builder: (context, state) => const NotesPage(),
        ),
        GoRoute(
          path: '/graph',
          builder: (context, state) => const GraphPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/notes/add',
      builder: (context, state) => const AddEditEntryPage(),
    ),
    GoRoute(
      path: '/notes/edit/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return AddEditEntryPage(entryId: id);
      },
    ),
  ],
);
