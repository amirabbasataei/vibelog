import 'package:flutter/material.dart';
import 'package:vibelog/l10n/app_localizations.dart';

class AddEditEntryPage extends StatelessWidget {
  const AddEditEntryPage({super.key, this.entryId});
  final int? entryId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(entryId == null ? l10n.addEntry : l10n.editEntry),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
