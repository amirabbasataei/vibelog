// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'vibelog';

  @override
  String get tabNotes => 'Notes';

  @override
  String get tabGraph => 'Graph';

  @override
  String get tabSettings => 'Settings';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get newEntry => 'New Entry';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get dateAndTimeLabel => 'Date & Time';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get mood => 'Mood';

  @override
  String get energy => 'Energy';

  @override
  String get boredom => 'Boredom';

  @override
  String get descriptionHint => 'How are you feeling?';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get todayAvgLabel => 'Today\'s Avg';

  @override
  String get dayStreakLabel => 'day streak';

  @override
  String get entriesLabel => 'entries';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get emptyNotes => 'No entries yet.\nTap + to add your first entry.';

  @override
  String get emptyGraph => 'Add at least 2 entries to see your graphs.';

  @override
  String get errorRetry => 'Something went wrong. Tap to retry.';

  @override
  String get retry => 'Retry';

  @override
  String get settingsScaleTitle => 'Score Scale';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsDangerZone => 'Danger Zone';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get deleteAllConfirmTitle => 'Delete all data?';

  @override
  String get deleteAllConfirmBody =>
      'This will permanently remove all entries. This action cannot be undone.';

  @override
  String get deleteAllConfirm => 'Delete';

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get moodOverTime => 'Mood Over Time';

  @override
  String get energyOverTime => 'Energy Over Time';

  @override
  String get boredomOverTime => 'Boredom Over Time';
}
