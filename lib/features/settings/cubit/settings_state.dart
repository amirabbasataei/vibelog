import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.scaleMax = 10,
    this.themeMode = ThemeMode.dark,
    this.locale = 'en',
    this.tutorialSeen = true,
  });

  final int scaleMax;
  final ThemeMode themeMode;
  final String locale;

  /// Whether the first-launch tutorial has been shown/dismissed.
  /// Defaults to `true` so the overlay never flashes before settings load;
  /// the real value is set in [SettingsCubit.loadSettings].
  final bool tutorialSeen;

  SettingsState copyWith({
    int? scaleMax,
    ThemeMode? themeMode,
    String? locale,
    bool? tutorialSeen,
  }) =>
      SettingsState(
        scaleMax: scaleMax ?? this.scaleMax,
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
        tutorialSeen: tutorialSeen ?? this.tutorialSeen,
      );

  @override
  List<Object?> get props => [scaleMax, themeMode, locale, tutorialSeen];
}
