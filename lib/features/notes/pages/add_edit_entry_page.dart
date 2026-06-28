import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/settings/cubit/settings_cubit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/mood_entry.dart';
import '../cubit/notes_cubit.dart';
import '../widgets/score_input_row.dart';

class AddEditEntryPage extends StatelessWidget {
  const AddEditEntryPage({super.key, this.entryId});
  final int? entryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotesCubit>(),
      child: _AddEditEntryView(entryId: entryId),
    );
  }
}

class _AddEditEntryView extends StatefulWidget {
  const _AddEditEntryView({this.entryId});
  final int? entryId;

  @override
  State<_AddEditEntryView> createState() => _AddEditEntryViewState();
}

class _AddEditEntryViewState extends State<_AddEditEntryView> {
  late DateTime _selectedDateTime;
  final _descController = TextEditingController();
  int _mood = 5;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    if (widget.entryId != null) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadEntry());
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadEntry() async {
    final entry =
        await context.read<NotesCubit>().getEntry(widget.entryId!);
    if (!mounted) return;
    if (entry != null) {
      setState(() {
        _selectedDateTime = entry.timestamp;
        _descController.text = entry.description;
        _mood = entry.mood;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (!mounted || time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final cubit = context.read<NotesCubit>();
    setState(() => _isSaving = true);

    final entry = MoodEntry(
      id: widget.entryId ?? 0,
      timestamp: _selectedDateTime,
      description: _descController.text.trim(),
      mood: _mood,
    );

    try {
      if (widget.entryId == null) {
        await cubit.addEntry(entry);
      } else {
        await cubit.updateEntry(entry);
      }
      if (!mounted) return;
      context.pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isEdit = widget.entryId != null;
    final scaleMax = context.watch<SettingsCubit>().state.scaleMax;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(context, l10n, isEdit),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateTimeCard(context, l10n, cs),
                          const SizedBox(height: 14),
                          _buildDescriptionField(context, l10n, cs),
                          const SizedBox(height: 14),
                          _buildScoresSectionLabel(l10n, cs),
                          const SizedBox(height: 8),
                          _buildScoresCard(context, l10n, cs, scaleMax),
                          const SizedBox(height: 18),
                          _buildSaveButton(context, l10n),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AppLocalizations l10n, bool isEdit) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outline, width: 1),
              ),
              child:
                  Icon(Icons.chevron_left, color: cs.onSurface, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            isEdit ? l10n.editEntry : l10n.newEntry,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeCard(
      BuildContext context, AppLocalizations l10n, ColorScheme cs) {
    final dateStr =
        DateFormat('EEE, d MMM · HH:mm').format(_selectedDateTime);
    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outline, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dateAndTimeLabel.toUpperCase(),
                    style: TextStyle(
                      color: cs.onSurfaceVariant.withAlpha(120),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: moodDim,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: moodColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField(
      BuildContext context, AppLocalizations l10n, ColorScheme cs) {
    return TextField(
      controller: _descController,
      maxLines: null,
      minLines: 5,
      style: TextStyle(
        color: cs.onSurface,
        fontSize: 14,
        height: 1.6,
      ),
      cursorColor: moodColor,
      decoration: InputDecoration(
        hintText: l10n.descriptionHint,
      ),
    );
  }

  Widget _buildScoresSectionLabel(AppLocalizations l10n, ColorScheme cs) {
    return Text(
      l10n.descriptionHint.toUpperCase(),
      style: TextStyle(
        color: cs.onSurfaceVariant.withAlpha(120),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildScoresCard(BuildContext context, AppLocalizations l10n,
      ColorScheme cs, int scaleMax) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outline, width: 1),
      ),
      child: ScoreInputRow(
        label: l10n.mood,
        value: _mood,
        color: moodColor,
        maxScore: scaleMax,
        onChanged: (v) => setState(() => _mood = v),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [moodColor, Color(0xFF7C5CF5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x667C5CF5),
              blurRadius: 28,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _isSaving ? null : _save,
            child: Center(
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      l10n.saveEntry,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
