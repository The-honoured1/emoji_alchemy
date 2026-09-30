import 'package:flutter/material.dart';

/// Ink & Paper — sumi ink on warm cream, editorial weight contrast.
class AppTheme {
  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color inkBlack    = Color(0xFF1C1612); // deep sumi ink
  static const Color inkSoft     = Color(0xFF2E2720); // slightly lifted dark
  static const Color paperCream  = Color(0xFFF5F0E8); // main background
  static const Color paperWarm   = Color(0xFFEADFC8); // slightly toasted
  static const Color stampRed    = Color(0xFFB85C2C); // red seal / accent
  static const Color sepiaGold   = Color(0xFF8B6914); // gold label accent
  static const Color hairline    = Color(0xFFC0A882); // borders on light
  static const Color darkHairline= Color(0xFF3D3228); // borders on dark
  static const Color paleText    = Color(0xFFEDE5D4); // text on dark surfaces
  static const Color mutedInk    = Color(0xFF7A6A58); // secondary on light

  static ThemeData get inkPaperTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: inkBlack,
      scaffoldBackgroundColor: paperCream,
      cardColor: inkBlack,
      canvasColor: paperWarm,
      dividerColor: hairline,
      highlightColor: stampRed,
      splashColor: stampRed.withValues(alpha: 0.14),
      shadowColor: inkBlack.withValues(alpha: 0.35),
      fontFamily: 'Georgia',
      appBarTheme: const AppBarTheme(
        backgroundColor: paperCream,
        foregroundColor: inkBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: inkBlack,
          fontFamily: 'Georgia',
          letterSpacing: 0.3,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: inkBlack,
          letterSpacing: -0.5,
          fontFamily: 'Georgia',
          height: 1.0,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: inkBlack,
          fontFamily: 'Georgia',
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: inkBlack,
          fontFamily: 'Georgia',
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: inkBlack,
          fontFamily: 'Georgia',
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: mutedInk,
          fontFamily: 'Georgia',
          letterSpacing: 0.8,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: stampRed,
          fontFamily: 'Georgia',
          letterSpacing: 1.4,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: inkBlack,
        secondary: stampRed,
        surface: paperCream,
        onPrimary: paleText,
        onSecondary: Colors.white,
        onSurface: inkBlack,
      ),
    );
  }
}
