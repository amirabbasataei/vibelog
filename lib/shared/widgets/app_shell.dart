import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibelog/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  int _locationToIndex(String location) {
    if (location.startsWith('/graph')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _locationToIndex(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/notes');
            case 1:
              context.go('/graph');
            case 2:
              context.go('/settings');
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.notes),
            label: l10n.tabNotes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart),
            label: l10n.tabGraph,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
