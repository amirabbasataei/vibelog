import 'package:flutter/material.dart';

// Brand colors — reference these across the app instead of hardcoding hex
const moodColor    = Color(0xFFA78BFA);
const energyColor  = Color(0xFFFBBF24);
const boredomColor = Color(0xFF34D399);
const moodDim      = Color(0x21A78BFA);  // ~13% alpha
const energyDim    = Color(0x21FBBF24);
const boredomDim   = Color(0x0D34D399);  // ~5% alpha
const lowColor     = Color(0xFFF87171);
const midColor     = Color(0xFFFBBF24);
const highColor    = Color(0xFF34D399);

// Dark palette
const _bgDark   = Color(0xFF08081A);
const _cardDark = Color(0xFF141428);
const _card2Dark   = Color(0xFF1C1C38);
const _t1Dark      = Color(0xFFEEEEF9);
const _t2Dark      = Color(0xFF8888B4);
const _t3Dark      = Color(0xFF4A4A72);
const _borderDark  = Color(0x17A78BFA);
const _borderDark2 = Color(0x0EFFFFFF);

const _seedColor = Color(0xFF6750A4);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: _seedColor,
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _bgDark,
  colorScheme: const ColorScheme.dark(
    primary: moodColor,
    onPrimary: Colors.white,
    primaryContainer: _card2Dark,
    onPrimaryContainer: moodColor,
    secondary: energyColor,
    tertiary: boredomColor,
    surface: Color(0xFF0F0F26),
    surfaceContainer: _cardDark,
    surfaceContainerHigh: _card2Dark,
    onSurface: _t1Dark,
    onSurfaceVariant: _t2Dark,
    outline: _borderDark,
    outlineVariant: _borderDark2,
    error: lowColor,
    onError: Colors.white,
  ),
  cardColor: _cardDark,
  cardTheme: const CardThemeData(
    color: _cardDark,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      side: BorderSide(color: _borderDark, width: 1),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(0xE60A0A19),
    indicatorColor: moodDim,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          color: moodColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        );
      }
      return const TextStyle(
        color: _t3Dark,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: moodColor, size: 22);
      }
      return const IconThemeData(color: _t3Dark, size: 22);
    }),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    height: 80,
  ),
  sliderTheme: const SliderThemeData(
    trackHeight: 7,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 18),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: _cardDark,
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: _borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: _borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Color(0x40A78BFA)),
    ),
    hintStyle: TextStyle(color: _t3Dark),
  ),
  dividerColor: _borderDark2,
  dividerTheme: const DividerThemeData(color: _borderDark2, thickness: 1),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: _card2Dark,
    contentTextStyle: TextStyle(color: _t1Dark),
    actionTextColor: moodColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: _borderDark),
    ),
    behavior: SnackBarBehavior.floating,
  ),
);
