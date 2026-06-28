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
  String get settingsAppearanceSection => 'APPEARANCE';

  @override
  String get settingsTrackingSection => 'TRACKING';

  @override
  String get settingsLanguageSection => 'LANGUAGE';

  @override
  String get settingsDataSection => 'DATA';

  @override
  String get settingsScaleTitle => 'Score Scale';

  @override
  String get settingsScaleSubtitle => 'Range for mood scores';

  @override
  String get settingsScaleOption5 => '0–5';

  @override
  String get settingsScaleOption10 => '0–10';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeSubtitle => 'App appearance';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'Auto';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'App display language';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageFa => 'فارسی';

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
  String get appVersion => 'vibelog v1.0.0';

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get moodOverTime => 'Mood Over Time';

  @override
  String get graphInsights => 'Insights';

  @override
  String get graph7d => '7D';

  @override
  String get graph30d => '30D';

  @override
  String get graphAll => 'All';

  @override
  String get graphAvgScore => 'avg score';

  @override
  String get tabMind => 'Mind Canvas';

  @override
  String get mindCanvasHint => 'Draw a closed shape to visualize a thought';

  @override
  String get thoughtNameDialogTitle => 'Name this thought';

  @override
  String get thoughtNameHint => 'e.g. Work stress, Anxiety...';

  @override
  String get thoughtSkip => 'Skip';

  @override
  String get thoughtDetailsTitle => 'Thought Details';

  @override
  String get thoughtCauseLabel => 'What caused this thought?';

  @override
  String get thoughtCauseHint => 'Describe the trigger...';

  @override
  String get thoughtRootLabel => 'Root of the thought';

  @override
  String get thoughtRootHint => 'What is the underlying reason?';

  @override
  String get thoughtResolutionLabel => 'Ways to resolve this';

  @override
  String get thoughtResolutionHint => 'What can help you feel better?';

  @override
  String get thoughtSaveDetails => 'Save Details';

  @override
  String get thoughtNoTitle => 'Untitled thought';

  @override
  String get settingsAboutSection => 'ABOUT';

  @override
  String get settingsGitHubTitle => 'Star us on GitHub';

  @override
  String get settingsGitHubSubtitle =>
      'vibelog is open source — we\'d love a star!';

  @override
  String get mindToolDraw => 'Draw';

  @override
  String get mindToolErase => 'Erase';

  @override
  String get mindToolSize => 'Size';

  @override
  String get mindClearTooltip => 'Clear all';

  @override
  String get mindClearTitle => 'Clear canvas';

  @override
  String get mindClearBody => 'Remove all strokes?';

  @override
  String get mindClearConfirm => 'Clear';

  @override
  String get mindStatusDrawHint =>
      'Tap & drag to draw • Return near the start point to close the shape';

  @override
  String get mindStatusEraseHint => 'Tap & drag to erase gradually';

  @override
  String get mindStatusDrawing => 'Drawing… keep going';

  @override
  String get mindStatusDrawingClose =>
      'Return close to the start ● to close & fill the shape';

  @override
  String get mindStatusErasing => 'Erasing…';

  @override
  String mindStrokeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count strokes',
      one: '1 stroke',
    );
    return '$_temp0';
  }

  @override
  String get tutorialWelcomeTitle => 'Welcome to vibelog';

  @override
  String get tutorialWelcomeBody =>
      'A calm space to track your mood and make sense of your thoughts.';

  @override
  String get tutorialNotesTitle => 'Notes';

  @override
  String get tutorialNotesBody =>
      'Log how you feel any time of day. Write as much as you like and rate your Mood';

  @override
  String get tutorialGraphTitle => 'Graph';

  @override
  String get tutorialGraphBody =>
      'Watch your mood unfold over time and spot the patterns behind your swings.';

  @override
  String get tutorialMindTitle => 'Mind Canvas';

  @override
  String get tutorialMindBody =>
      'Give a thought a form, name it, then explore what caused it, its root, and gentle ways to work through it.';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialDone => 'Get Started';
}
