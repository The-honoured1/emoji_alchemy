import 'package:flutter/material.dart';

/// Clean, minimal aesthetic — structured grids and breathing room.
class AppTheme {
  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color inkBlack    = Color(0xFF0F0F0F); // near-black, no warmth
  static const Color offWhite    = Color(0xFFFAFAFA); // cool white
  static const Color lightGray   = Color(0xFFF0F0F0); // grid background
  static const Color mediumGray  = Color(0xFFE0E0E0); // borders
  static const Color darkGray    = Color(0xFF707070); // secondary text
  static const Color accentOrange = Color(0xFFE8694B); // warm, single accent
  static const Color paleText    = Color(0xFFE8E8E8); // text on dark

  static ThemeData get inkPaperTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: inkBlack,
      scaffoldBackgroundColor: offWhite,
      cardColor: inkBlack,
      canvasColor: lightGray,
      dividerColor: mediumGray,
      highlightColor: accentOrange,
      splashColor: accentOrange.withValues(alpha: 0.08),
      shadowColor: Colors.transparent, // NO glows
      fontFamily: 'system',
      useMaterial3: false,
      appBarTheme: const AppBarTheme(
        backgroundColor: offWhite,
        foregroundColor: inkBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: inkBlack,
          fontFamily: 'system',
          letterSpacing: 0,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: inkBlack,
          letterSpacing: -1,
          fontFamily: 'system',
          height: 1.1,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: inkBlack,
          fontFamily: 'system',
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: inkBlack,
          fontFamily: 'system',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: inkBlack,
          fontFamily: 'system',
          height: 1.6,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: darkGray,
          fontFamily: 'system',
          letterSpacing: 0,
        ),
        labelLarge: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: accentOrange,
          fontFamily: 'system',
          letterSpacing: 0.5,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: inkBlack,
        secondary: accentOrange,
        surface: offWhite,
        onPrimary: paleText,
        onSecondary: Colors.white,
        onSurface: inkBlack,
      ),
    );
  }
}
