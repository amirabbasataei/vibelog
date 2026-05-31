import 'package:flutter/material.dart';
import 'package:vibelog/l10n/app_localizations.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(child: Text(l10n.tabGraph)),
    );
  }
}
