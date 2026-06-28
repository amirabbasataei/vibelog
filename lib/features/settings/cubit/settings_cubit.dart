import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      scaleMax: prefs.getInt('scale_max') ?? 5,
      themeMode: _parseTheme(prefs.getString('theme_mode') ?? 'system'),
      locale: prefs.getString('locale_code') ?? 'fa',
      tutorialSeen: prefs.getBool('tutorial_seen') ?? false,
    ));
  }

  Future<void> markTutorialSeen() async {
    if (state.tutorialSeen) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_seen', true);
    emit(state.copyWith(tutorialSeen: true));
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

  Future<void> setLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_code', code);
    emit(state.copyWith(locale: code));
  }

  ThemeMode _parseTheme(String s) => switch (s) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
