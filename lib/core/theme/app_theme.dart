import 'package:flutter/material.dart';

const _seedColor = Color(0xFF6750A4);

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
