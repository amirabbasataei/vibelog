# vibelog — Claude Code Project Instructions

## What This App Is

**vibelog** is a Flutter mood-tracking app for users who experience mood swings.  
At any hour of the day, users can log an entry that captures:

- A **free-text description** of their mental/physical state (can be very long — no limits)
- Three integer scores on a **0–10** scale:
  - **Mood** — emotional state

Entries can be **created** and **edited** at any time. Three **line graphs** plot each score over time.  
The app has a **bottom navigation bar** with three tabs: **Notes**, **Graph**, **Settings**.

---

## Tech Stack

| Concern              | Package                     | Reason                                                             |
|----------------------|-----------------------------|--------------------------------------------------------------------|
| State management     | `flutter_bloc` (Cubit)      | Simple, testable, no boilerplate overhead                          |
| Navigation           | `go_router`                 | Declarative, ShellRoute for persistent bottom nav                  |
| Dependency injection | `get_it`                    | Service locator; simple and fast                                   |
| Local database       | `drift` (SQLite)            | SQLite TEXT has no length limit — safe for long journal entries; reactive streams pair naturally with Cubit |
| Charts               | `fl_chart`                  | Best Flutter line chart library, touch callbacks, customisable     |
| Equality             | `equatable`                 | Clean `==` on state/model classes                                  |
| Formatting           | `intl`                      | Date/time formatting for graph axis and cards                      |
| Preferences          | `shared_preferences`        | Persist Settings (theme, scale) without a full DB                  |
| Localization         | `flutter_localizations`     | SDK bundle — ARB-based l10n for Persian (fa) and English (en)      |

---

## pubspec.yaml

```yaml
name: vibelog
description: Mood tracking app for people with mood swings.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Navigation
  go_router: ^14.3.0

  # Dependency injection
  get_it: ^7.7.0

  # Database
  drift: ^2.21.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.4
  path: ^1.9.0

  # Charts
  fl_chart: ^0.69.0

  # Date/time
  intl: ^0.19.0

  # Settings persistence
  shared_preferences: ^2.3.0

flutter:
  generate: true   # enables flutter gen-l10n from l10n.yaml

dependencies:
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  drift_dev: ^2.21.0
  build_runner: ^2.4.13
```

---

## Architecture: Feature-Based (NOT Clean Architecture)

> ⛔ **NEVER apply Clean Architecture (also called Killian Architecture).**  
> - No `domain/` layer  
> - No Use Cases or Interactors  
> - No abstract Repository interfaces in a separate layer  
> - Keep it pragmatic and direct

**Feature-based** means code is grouped by **feature**, not by technical layer.  
Each feature under `lib/features/` is self-contained and owns its cubit, pages, widgets, and repository.  
A repository is a **concrete class** — just a data-access helper that talks to the DAO.

### Within each feature folder

```
features/<name>/
  cubit/        ← Cubit class + sealed State class (one file each)
  pages/        ← Full-screen route widgets
  widgets/      ← Feature-specific smaller widgets
  repository/   ← Concrete repository class (no interface, no abstraction)
```

---

## Full Folder Structure

```
vibelog/
├── l10n.yaml                               # flutter gen-l10n config
├── lib/
│   ├── l10n/
│   │   ├── app_en.arb                      # English strings (source of truth)
│   │   └── app_fa.arb                      # Persian strings
│   ├── main.dart                           # Entry point: setupDependencies(), runApp()
│   ├── app.dart                            # MaterialApp.router with appRouter + theme
│   │
│   ├── core/
│   │   ├── di/
│   │   │   └── injection.dart             # get_it registrations (all singletons/factories)
│   │   ├── router/
│   │   │   └── app_router.dart            # GoRouter config + ShellRoute
│   │   └── theme/
│   │       └── app_theme.dart             # ThemeData light + dark, seed color
│   │
│   ├── database/
│   │   ├── app_database.dart              # @DriftDatabase class, LazyDatabase setup
│   │   ├── app_database.g.dart            # GENERATED — do not edit
│   │   ├── tables/
│   │   │   └── mood_entries_table.dart    # Drift Table definition
│   │   └── dao/
│   │       └── mood_entries_dao.dart      # All CRUD queries and watch streams
│   │
│   ├── features/
│   │   │
│   │   ├── notes/
│   │   │   ├── repository/
│   │   │   │   └── notes_repository.dart
│   │   │   ├── cubit/
│   │   │   │   ├── notes_cubit.dart
│   │   │   │   └── notes_state.dart
│   │   │   ├── pages/
│   │   │   │   ├── notes_page.dart
│   │   │   │   └── add_edit_entry_page.dart
│   │   │   └── widgets/
│   │   │       ├── mood_entry_card.dart
│   │   │       └── score_input_row.dart
│   │   │
│   │   ├── graph/
│   │   │   ├── repository/
│   │   │   │   └── graph_repository.dart
│   │   │   ├── cubit/
│   │   │   │   ├── graph_cubit.dart
│   │   │   │   └── graph_state.dart
│   │   │   ├── pages/
│   │   │   │   └── graph_page.dart
│   │   │   └── widgets/
│   │   │       └── score_line_chart.dart
│   │   │
│   │   └── settings/
│   │       ├── cubit/
│   │       │   ├── settings_cubit.dart
│   │       │   └── settings_state.dart
│   │       ├── pages/
│   │       │   └── settings_page.dart
│   │       └── widgets/
│   │           └── settings_section.dart
│   │
│   └── shared/
│       ├── models/
│       │   └── mood_entry.dart            # Pure Dart model — no DB imports
│       └── widgets/
│           ├── app_shell.dart             # Bottom nav + ShellRoute child
│           └── empty_state_widget.dart
│
├── test/
└── pubspec.yaml
```

---

## Data Model

### `lib/shared/models/mood_entry.dart`

```dart
import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.description,
    required this.mood,
  });

  final int id;
  final DateTime timestamp;
  final String description; // Unlimited length — SQLite TEXT
  final int mood;           // 0–10

  MoodEntry copyWith({
    int? id,
    DateTime? timestamp,
    String? description,
    int? mood,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      mood: mood ?? this.mood,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, description, mood];
}
```

---

## Database Layer

### `lib/database/tables/mood_entries_table.dart`

```dart
import 'package:drift/drift.dart';

class MoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get description => text()(); // No maxLength — TEXT is unlimited in SQLite
  IntColumn get mood => integer()();
}
```

### `lib/database/app_database.dart`

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/mood_entries_table.dart';
import 'dao/mood_entries_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MoodEntries], daos: [MoodEntriesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vibelog.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

After writing these files, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### `lib/database/dao/mood_entries_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/mood_entries_table.dart';

part 'mood_entries_dao.g.dart';

@DriftAccessor(tables: [MoodEntries])
class MoodEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$MoodEntriesDaoMixin {
  MoodEntriesDao(super.db);

  // Watch all entries — newest first; emits whenever DB changes
  Stream<List<MoodEntry>> watchAllEntries() =>
      (select(moodEntries)..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .watch();

  // One-shot fetch (for graph)
  Future<List<MoodEntry>> getAllEntriesOnce() =>
      (select(moodEntries)..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .get();

  Future<void> insertEntry(MoodEntriesCompanion entry) =>
      into(moodEntries).insert(entry);

  Future<void> updateEntry(MoodEntriesCompanion entry) =>
      (update(moodEntries)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> deleteEntry(int id) =>
      (delete(moodEntries)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAllEntries() => delete(moodEntries).go();
}
```

---

## Dependency Injection

### `lib/core/di/injection.dart`

```dart
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
  // Database
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<MoodEntriesDao>(
    MoodEntriesDao(getIt<AppDatabase>()),
  );

  // Repositories
  getIt.registerSingleton<NotesRepository>(
    NotesRepository(getIt<MoodEntriesDao>()),
  );
  getIt.registerSingleton<GraphRepository>(
    GraphRepository(getIt<MoodEntriesDao>()),
  );

  // Cubits — factory so each page gets a fresh instance
  getIt.registerFactory<NotesCubit>(
    () => NotesCubit(getIt<NotesRepository>()),
  );
  getIt.registerFactory<GraphCubit>(
    () => GraphCubit(getIt<GraphRepository>()),
  );

  // Settings cubit — singleton so preference state persists across tabs
  final settingsCubit = SettingsCubit();
  await settingsCubit.loadSettings();
  getIt.registerSingleton<SettingsCubit>(settingsCubit);
}
```

### `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const VibelogApp());
}
```

---

## Routing

### `lib/core/router/app_router.dart`

```dart
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
    // These sit OUTSIDE the ShellRoute so they render full-screen (no bottom nav)
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
```

### `lib/shared/widgets/app_shell.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _locationToIndex(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0: context.go('/notes');
            case 1: context.go('/graph');
            case 2: context.go('/settings');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.notes), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Graph'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
```

---

## State Management Conventions

Use **Dart 3 sealed classes** for states. Pattern-match exhaustively with `switch`.

### Example: Notes

```dart
// notes_state.dart
sealed class NotesState extends Equatable {
  const NotesState();
  @override List<Object?> get props => [];
}
class NotesInitial  extends NotesState { const NotesInitial(); }
class NotesLoading  extends NotesState { const NotesLoading(); }
class NotesLoaded   extends NotesState {
  const NotesLoaded(this.entries);
  final List<MoodEntry> entries;
  @override List<Object?> get props => [entries];
}
class NotesError    extends NotesState {
  const NotesError(this.message);
  final String message;
  @override List<Object?> get props => [message];
}
```

```dart
// notes_cubit.dart
class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._repository) : super(const NotesInitial());
  final NotesRepository _repository;
  StreamSubscription<List<MoodEntry>>? _sub;

  void watchEntries() {
    emit(const NotesLoading());
    _sub = _repository.watchAll().listen(
      (entries) => emit(NotesLoaded(entries)),
      onError: (e) => emit(NotesError(e.toString())),
    );
  }

  Future<void> addEntry(MoodEntry entry) => _repository.add(entry);
  Future<void> updateEntry(MoodEntry entry) => _repository.update(entry);
  Future<void> deleteEntry(int id) => _repository.delete(id);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
```

The same sealed-class pattern applies to `GraphState` and `SettingsState`.

---

## Feature: Notes Tab

### `NotesPage`
- Provide `NotesCubit` via `BlocProvider(create: (_) => getIt<NotesCubit>()..watchEntries())`
- `BlocBuilder` pattern-matches `NotesState`:
  - `NotesInitial` / `NotesLoading` → centered `CircularProgressIndicator`
  - `NotesLoaded` with empty list → `EmptyStateWidget`
  - `NotesLoaded` with entries → `ListView.builder` of `MoodEntryCard`
  - `NotesError` → error message + retry button
- FAB navigates to `/notes/add` with `context.push('/notes/add')`
- `MoodEntryCard` tap → `context.push('/notes/edit/$id')`
- Swipe-to-delete with `Dismissible`; show undo `SnackBar`

### `MoodEntryCard`
Shows:
- Formatted `timestamp` (e.g. "Mon, 23 May · 14:32")
- Description preview — one line, `TextOverflow.ellipsis`

### `AddEditEntryPage`
- `entryId` is nullable; `null` = add mode, non-null = edit mode (fetch entry on init)
- **DateTime picker**: `showDatePicker` + `showTimePicker` combined; defaults to `DateTime.now()`
- **Description field**: `TextField` with `maxLines: null`, `minLines: 5`, `expands: false`, no character limit
- **Score inputs**: One `ScoreInputRow` per metric. Each row has the label, a `Slider` (`min:0`, `max:10`, `divisions:10`) and the integer value displayed to the right
- Validate: all three scores must have been touched OR default to 5 if untouched
- "Save" button calls `cubit.addEntry()` or `cubit.updateEntry()`, then `context.pop()`
- In edit mode, prefill all fields from the fetched entry

---

## Feature: Graph Tab

### `ScoreLineChart` widget (reusable)
Parameters:
```dart
ScoreLineChart({
  required String title,       // "Mood Over Time"
  required List<FlSpot> spots, // x = ms-since-epoch as double, y = score
  required Color color,
  required double maxY,        // 10.0 or 5.0 from settings
});
```

Implementation notes:
- Use `fl_chart`'s `LineChart`
- `titlesData`: left axis 0–maxY in steps of 2; bottom axis shows date labels — but only show 5–6 labels max regardless of entry count (use `getTitlesWidget` with modulo logic or a computed interval)
- Convert `DateTime` to `double` for x: `timestamp.millisecondsSinceEpoch.toDouble()`
- Convert back for display: `DateTime.fromMillisecondsSinceEpoch(value.toInt())`
- Format with `DateFormat('MMM d', 'en')` from `intl`
- Enable `LineTouchData` with a `TouchTooltip` showing date + score
- Dot: `dotData: FlDotData(show: true)` with radius 4
- Smooth curve: `isCurved: true`, `curveSmoothness: 0.25`

### `GraphPage`
- Provide `GraphCubit` via `BlocProvider(create: (_) => getIt<GraphCubit>()..loadEntries())`
- Also read `SettingsCubit` from context to get current `maxScale` (10 or 5)
- `BlocBuilder` on `GraphState`:
  - `GraphLoading` → `CircularProgressIndicator`
  - `GraphLoaded` with fewer than 2 entries → `EmptyStateWidget` with copy "Add at least 2 entries to see your graphs"
  - `GraphError` → error text

### `GraphRepository`

```dart
class GraphRepository {
  GraphRepository(this._dao);
  final MoodEntriesDao _dao;

  Future<List<MoodEntry>> getAllEntries() async {
    final rows = await _dao.getAllEntriesOnce();
    return rows.map(_toModel).toList();
  }
}
```

### `GraphCubit`

```dart
class GraphCubit extends Cubit<GraphState> {
  GraphCubit(this._repository) : super(const GraphInitial());
  final GraphRepository _repository;

  Future<void> loadEntries() async {
    emit(const GraphLoading());
    try {
      final entries = await _repository.getAllEntries();
      emit(GraphLoaded(entries));
    } catch (e) {
      emit(GraphError(e.toString()));
    }
  }
}
```

---

## Feature: Settings Tab

### Settings stored in `SharedPreferences`

| Key                  | Type    | Default  | Meaning                          |
|----------------------|---------|----------|----------------------------------|
| `scale_max`          | `int`   | `10`     | Max value for sliders/graph      |
| `theme_mode`         | `String`| `system` | `light` / `dark` / `system`      |

### `SettingsCubit`

```dart
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      scaleMax: prefs.getInt('scale_max') ?? 10,
      themeMode: _parseTheme(prefs.getString('theme_mode') ?? 'system'),
    ));
  }

  Future<void> setScaleMax(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('scale_max', value);
    emit(state.copyWith(scaleMax: value));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  ThemeMode _parseTheme(String s) => switch (s) {
    'light' => ThemeMode.light,
    'dark'  => ThemeMode.dark,
    _       => ThemeMode.system,
  };
}
```

### `SettingsState`

```dart
class SettingsState extends Equatable {
  const SettingsState({this.scaleMax = 10, this.themeMode = ThemeMode.system});
  final int scaleMax;
  final ThemeMode themeMode;
  SettingsState copyWith({int? scaleMax, ThemeMode? themeMode}) => ...;
  @override List<Object?> get props => [scaleMax, themeMode];
}
```

### `SettingsPage` sections

1. **Language** — `SegmentedButton<String>` with options `en` and `fa`; calls `settingsCubit.setLocale()`
2. **Theme** — `SegmentedButton<ThemeMode>` with Light / Dark / System; calls `settingsCubit.setThemeMode()`
3. **Danger Zone** — "Delete all data" `OutlinedButton` with red color; shows `AlertDialog` for confirmation; calls `notesRepository.deleteAll()`

---

## Localization

The app is **bilingual: English (en) and Persian (fa)**. Persian is RTL; the UI must adapt automatically via Flutter's `Directionality` widget (handled by `MaterialApp` when the locale is `fa`).

**No string may be hardcoded in any widget or class.** Every user-visible string must come from `AppLocalizations.of(context)!`.

### Setup files

**`l10n.yaml`** (project root):
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**`lib/l10n/app_en.arb`** (English — source of truth; add every new string here first):
```json
{
  "@@locale": "en",
  "appTitle": "vibelog",
  "tabNotes": "Notes",
  "tabGraph": "Graph",
  "tabSettings": "Settings"
}
```

**`lib/l10n/app_fa.arb`** (Persian):
```json
{
  "@@locale": "fa",
  "appTitle": "وایب‌لاگ",
  "tabNotes": "یادداشت‌ها",
  "tabGraph": "نمودار",
  "tabSettings": "تنظیمات"
}
```

After adding or renaming any ARB key, regenerate:
```bash
flutter gen-l10n
```

### Wiring into `app.dart`

Add `localizationsDelegates` and `supportedLocales` to `MaterialApp.router`:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp.router(
  title: 'vibelog',
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('fa'),
  ],
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: settings.themeMode,
  routerConfig: appRouter,
);
```

### Using strings in widgets

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Inside build():
final l10n = AppLocalizations.of(context)!;
Text(l10n.mood);
```

### Language preference in Settings

Add a `locale` field to `SettingsState` and `SettingsCubit`:

| Key             | Type     | Default | Meaning              |
|-----------------|----------|---------|----------------------|
| `locale_code`   | `String` | `en`    | `en` or `fa`         |

`SettingsPage` adds a third `SegmentedButton<String>` with options `en` (English / انگلیسی) and `fa` (فارسی / Persian). Changing it calls `settingsCubit.setLocale()`, which persists to `SharedPreferences` and emits the new state. `app.dart` reads `settings.locale` and passes `Locale(settings.locale)` as `locale:` to `MaterialApp.router`.

### RTL notes

- Flutter's `MaterialApp` automatically mirrors layout direction when `locale` is `fa` — no manual `Directionality` wrappers needed.
- Do not hard-code `TextAlign.left` / `TextAlign.right`; use `TextAlign.start` / `TextAlign.end`.
- Avoid `EdgeInsets.only(left:…)` / `only(right:…)`; use `EdgeInsetsDirectional.only(start:…, end:…)`.

---

## Theme

### `lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

const _seedColor = Color(0xFF6750A4); // Vibrant purple — fits "vibe"

final lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: _seedColor,
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: _seedColor,
  brightness: Brightness.dark,
);
```

### `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/cubit/settings_cubit.dart';
import 'features/settings/cubit/settings_state.dart';

class VibelogApp extends StatelessWidget {
  const VibelogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'vibelog',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settings.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
```

---

## Code Rules (Strictly Enforced)

1. **No Clean Architecture** — No `domain/` folders, no Use Cases, no abstract Repository interfaces. Repositories are plain concrete classes.

2. **Sealed states** — Every Cubit uses Dart 3 `sealed class` for its state hierarchy. Always exhaustively `switch` on state in `BlocBuilder`.

3. **No BuildContext across async gaps** — Always check `if (!mounted) return;` before using `context` after any `await`.

4. **Reactive DB** — Use `watchAllEntries()` (returns `Stream`) in `NotesRepository`/`NotesCubit` for the list; use one-shot `getAllEntriesOnce()` in `GraphRepository`. Always cancel `StreamSubscription` in `Cubit.close()`.

5. **Navigation** — Use `context.go()` for tab switching (replaces history), `context.push()` for sub-routes like add/edit (preserves back button).

6. **get_it access** — Only resolve dependencies in: `main.dart`, `injection.dart`, and `BlocProvider(create:)` callbacks. Never call `getIt<>()` deep inside widget `build` methods.

7. **No magic numbers for colors** — Use `Theme.of(context).colorScheme.*` tokens everywhere. Only define actual color values in `app_theme.dart`.

8. **Description TextField** — Always `maxLines: null`, `minLines: 5`. Never add `maxLength`.

9. **Score Sliders** — `min: 0`, `max: scaleMax.toDouble()`, `divisions: scaleMax`, value always stored/displayed as integer. Read `scaleMax` from `SettingsCubit` via `context.watch`.

10. **Drift codegen** — After any change to tables or DAOs, run: `dart run build_runner build --delete-conflicting-outputs`

11. **No hardcoded strings** — Every user-visible string (labels, messages, tooltips, button text, dialog copy) must be defined in `lib/l10n/app_en.arb` and `lib/l10n/app_fa.arb`, then accessed via `AppLocalizations.of(context)!`. Never pass a string literal directly to a widget.

12. **RTL-safe layout** — Use `TextAlign.start`/`TextAlign.end` (never `left`/`right`). Use `EdgeInsetsDirectional` (never `EdgeInsets.only(left:…)`). Flutter mirrors the layout automatically for the `fa` locale.

---

## Implementation Phases

See [PLAN.md](PLAN.md) for the full phased implementation plan.

---

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| `build_runner` not regenerating | Delete `.g.dart` files, re-run with `--delete-conflicting-outputs` |
| Bottom nav doesn't highlight correct tab | Use `GoRouterState.of(context).uri.path` inside `AppShell`, not a local index state variable |
| `context.push('/notes/add')` keeps bottom nav | Move add/edit routes OUTSIDE ShellRoute so they render full-screen |
| Slider value is `double` but model uses `int` | Always `slider.value.round()` when reading; `entry.mood.toDouble()` when setting `Slider.value` |
| `StreamSubscription` leak | Override `Cubit.close()` and call `_sub?.cancel()` in every cubit that subscribes |
| Long text breaks layout in card | Use `TextOverflow.ellipsis` and a `maxLines` constraint only on the preview line in `MoodEntryCard`; the full text is always available in the edit page |
| Graph X-axis label overlap | Compute an interval: `interval = max(1, (entries.length / 5).floor())` and only show a label when `index % interval == 0` |
| `flutter gen-l10n` output missing | Ensure `flutter: generate: true` is in `pubspec.yaml` and `l10n.yaml` exists at project root; run `flutter gen-l10n` (not `build_runner`) |
| Layout breaks in Persian (RTL) | Replace `EdgeInsets.only(left/right)` with `EdgeInsetsDirectional.only(start/end)` and `TextAlign.left/right` with `TextAlign.start/end` |
| `AppLocalizations.of(context)` returns null | Confirm `AppLocalizations.delegate` is in `localizationsDelegates` in `app.dart` and the widget is inside `MaterialApp` |
