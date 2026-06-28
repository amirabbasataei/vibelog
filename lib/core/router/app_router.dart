import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection.dart';
import '../../features/mind/cubit/drawing_cubit.dart';
import '../../features/settings/cubit/settings_cubit.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../shared/widgets/app_shell.dart';
import '../../features/notes/pages/notes_page.dart';
import '../../features/notes/pages/add_edit_entry_page.dart';
import '../../features/graph/pages/graph_page.dart';
import '../../features/mind/pages/mind_page.dart';
import '../../features/mind/pages/thought_details_page.dart';
import '../../features/settings/pages/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/notes',
  // Rebuild redirects whenever settings (incl. tutorialSeen) change.
  refreshListenable: _StreamListenable(getIt<SettingsCubit>().stream),
  redirect: (context, state) {
    final seen = getIt<SettingsCubit>().state.tutorialSeen;
    final atTutorial = state.matchedLocation == '/tutorial';
    if (!seen && !atTutorial) return '/tutorial';
    if (seen && atTutorial) return '/notes';
    return null;
  },
  routes: [
    // Full-screen first-launch tutorial — sits OUTSIDE the ShellRoute.
    GoRoute(
      path: '/tutorial',
      builder: (context, state) => const OnboardingPage(),
    ),
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
          path: '/mind',
          builder: (context, state) => const MindPage(),
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
    GoRoute(
      path: '/mind/thought/:shapeId',
      builder: (context, state) {
        final shapeId = state.pathParameters['shapeId']!;
        return BlocProvider.value(
          value: getIt<DrawingCubit>(),
          child: ThoughtDetailsPage(shapeId: shapeId),
        );
      },
    ),
  ],
);

/// Bridges a [Stream] to a [Listenable] so GoRouter re-evaluates redirects
/// whenever the stream emits (here: when settings change).
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
