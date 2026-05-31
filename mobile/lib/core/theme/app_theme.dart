import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MH StayHub - Premium Design System (Material 3)
class AppTheme {
  // Brand Colors matching the web platform
  static const Color brandPrimary = Color(0xFF6C3CE1);
  static const Color brandPrimaryLight = Color(0xFF8B5CF6);
  static const Color brandPrimaryDark = Color(0xFF5521C5);
  static const Color brandSecondary = Color(0xFF14B8A6);
  static const Color brandAccent = Color(0xFFF59E0B);

  // Surface Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        primary: brandPrimary,
        secondary: brandSecondary,
        tertiary: brandAccent,
        background: background,
        surface: surface,
        error: error,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
        titleLarge: textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.w700),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }
}
