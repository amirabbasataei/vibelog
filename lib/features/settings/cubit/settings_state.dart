import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.scaleMax = 10,
    this.themeMode = ThemeMode.dark,
    this.locale = 'en',
  });

  final int scaleMax;
  final ThemeMode themeMode;
  final String locale;

  SettingsState copyWith({
    int? scaleMax,
    ThemeMode? themeMode,
    String? locale,
  }) =>
      SettingsState(
        scaleMax: scaleMax ?? this.scaleMax,
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );

  @override
  List<Object?> get props => [scaleMax, themeMode, locale];
}
