# vibelog — Implementation Plan

## Phase 1 — Foundation & Shell
**Goal: App launches, three tabs switch, no crashes.**

Steps:
1. `flutter create vibelog --org com.vibelog`
2. Replace `pubspec.yaml` with the one above; run `flutter pub get`
3. Create `l10n.yaml` at the project root and `lib/l10n/app_en.arb` + `lib/l10n/app_fa.arb` with all strings; run `flutter gen-l10n`
4. Create the full folder structure (stub all `.dart` files with `// TODO`)
5. Implement database layer:
   - `mood_entries_table.dart`
   - `app_database.dart`
   - `mood_entries_dao.dart`
   - Run `dart run build_runner build --delete-conflicting-outputs`
6. Implement `injection.dart` and `app_theme.dart`
7. Implement `app_router.dart` with ShellRoute
8. Implement `app_shell.dart` (bottom nav — use `l10n` for destination labels)
9. Implement `app.dart` with `localizationsDelegates`, `supportedLocales`, and locale from `SettingsCubit`
10. Implement `main.dart`
11. Stub all three tab pages as plain `Scaffold` with a centered `Text(l10n.tabNotes)` etc.
12. ✅ Verify: app launches, bottom nav switches tabs, switching locale flips RTL/LTR

---

## Phase 2 — Notes Feature
**Goal: Full CRUD on mood entries.**

Steps:
1. Implement `shared/models/mood_entry.dart`
2. Implement `NotesRepository` (watchAll, add, update, delete, deleteAll)
3. Implement `NotesState` (sealed) and `NotesCubit`
4. Implement `ScoreInputRow` widget
5. Implement `AddEditEntryPage`:
   - DateTime picker (date + time)
   - Description `TextField`
   - Three `ScoreInputRow` for Mood / Energy / Boredom
   - Save button with validation
6. Implement `MoodEntryCard` widget
7. Implement `NotesPage` with BlocBuilder, ListView, FAB, swipe-delete
8. Register `NotesCubit` factory in `injection.dart`
9. Wire `/notes/add` and `/notes/edit/:id` routes
10. ✅ Verify: add entry, see it in list, tap to edit, swipe to delete

---

## Phase 3 — Graph Feature
**Goal: Three line graphs render with real data.**

Steps:
1. Implement `GraphRepository` (getAllEntries one-shot)
2. Implement `GraphState` (sealed) and `GraphCubit`
3. Implement reusable `ScoreLineChart` widget with `fl_chart`
4. Implement `GraphPage` with three `ScoreLineChart` instances
5. Connect `SettingsCubit.scaleMax` to graph Y-axis and `ScoreLineChart.maxY`
6. Implement empty state (< 2 entries)
7. Implement date formatting on X-axis with `intl`
8. Add touch tooltip
9. ✅ Verify: graphs render correctly; adding/editing entries updates Notes tab (graph still requires manual refresh or pull-to-refresh)

---

## Phase 4 — Settings & Polish
**Goal: Settings persist, all edge cases handled.**

Steps:
1. Implement `SettingsState` and `SettingsCubit` with `SharedPreferences`
2. Implement `SettingsPage` (scale toggle, theme toggle, delete-all)
3. Connect `scaleMax` to `AddEditEntryPage` sliders (read via `context.watch<SettingsCubit>()`)
4. Connect `themeMode` to `MaterialApp.router` in `app.dart` (already wired; verify)
5. Implement `EmptyStateWidget` (icon + message) used in Notes and Graph
6. Add loading states everywhere (replace stubs with `CircularProgressIndicator`)
7. Add error states everywhere (retry button)
8. Accessibility: `Semantics` labels on sliders, meaningful `tooltip` on FAB
9. Test on iOS Simulator + Android Emulator
10. ✅ Verify: full app flow end-to-end, settings persist across restarts
