import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// MH StayHub - Premium Design System v2
/// Unified with the Next.js web design tokens.
class AppTheme {
  // ─── Brand Colors (identical to web --brand-*) ──────────────────
  static const Color brandPrimary = Color(0xFF6C3CE1);
  static const Color brandPrimaryLight = Color(0xFF8B5CF6);
  static const Color brandPrimaryDark = Color(0xFF5521C5);
  static const Color brandSecondary = Color(0xFF14B8A6);
  static const Color brandAccent = Color(0xFFF59E0B);

  // ─── Semantic (identical to web) ────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color error = Color(0xFFEF4444);

  // ─── Light surfaces (identical to web :root) ────────────────────
  static const Color background = Color(0xFFF8F9FC);
  static const Color foreground = Color(0xFF111827);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF1F3F8);
  static const Color surfaceHover = Color(0xFFEEF0F6);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE2E5EC);

  // ─── Dark surfaces (identical to web [data-theme='dark']) ───────
  static const Color backgroundDark = Color(0xFF0B0F19);
  static const Color foregroundDark = Color(0xFFF1F3F8);
  static const Color surfaceDark = Color(0xFF131825);
  static const Color surfaceAltDark = Color(0xFF161C2C);
  static const Color surfaceHoverDark = Color(0xFF1C2333);
  static const Color mutedDark = Color(0xFF8B95A8);
  static const Color borderDark = Color(0xFF252D3D);

  // ─── Radius tokens ──────────────────────────────────────────────
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;

  // ─── Backwards-compatible aliases ───────────────────────────────
  static const Color textPrimary = foreground;
  static const Color textSecondary = muted;

  // ═══════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    final baseText = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        primary: brandPrimary,
        secondary: brandSecondary,
        tertiary: brandAccent,
        surface: surface,
        error: error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      textTheme: _buildTextTheme(baseText, foreground, muted),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.inter(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: -0.3,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: brandPrimary.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: brandPrimary);
          }
          return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: muted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: brandPrimary, size: 22);
          }
          return const IconThemeData(color: muted, size: 22);
        }),
        elevation: 0,
        height: 64,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandPrimary,
          side: BorderSide(color: brandPrimary.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusLg), borderSide: BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusLg), borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusLg), borderSide: const BorderSide(color: brandPrimary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(color: muted, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
          side: const BorderSide(color: border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAlt,
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: foreground),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    final baseText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        primary: brandPrimaryLight,
        secondary: brandSecondary,
        tertiary: brandAccent,
        surface: surfaceDark,
        error: error,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: _buildTextTheme(baseText, foregroundDark, mutedDark),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: foregroundDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.inter(
          color: foregroundDark,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: -0.3,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: brandPrimaryLight.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: brandPrimaryLight);
          }
          return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: mutedDark);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: brandPrimaryLight, size: 22);
          }
          return const IconThemeData(color: mutedDark, size: 22);
        }),
        elevation: 0,
        height: 64,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandPrimaryLight,
          side: BorderSide(color: brandPrimaryLight.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAltDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusLg), borderSide: const BorderSide(color: borderDark)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusLg), borderSide: const BorderSide(color: borderDark)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusLg), borderSide: const BorderSide(color: brandPrimaryLight, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(color: mutedDark, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
          side: const BorderSide(color: borderDark),
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderDark, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAltDark,
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: foregroundDark),
        side: const BorderSide(color: borderDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }

  // ─── Shared text theme builder ──────────────────────────────────
  static TextTheme _buildTextTheme(TextTheme base, Color primary, Color secondary) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: primary, fontWeight: FontWeight.w800, letterSpacing: -1.5),
      displayMedium: base.displayMedium?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -1.0),
      displaySmall: base.displaySmall?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineLarge: base.headlineLarge?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineMedium: base.headlineMedium?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      headlineSmall: base.headlineSmall?.copyWith(color: primary, fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleMedium: base.titleMedium?.copyWith(color: primary, fontWeight: FontWeight.w600),
      titleSmall: base.titleSmall?.copyWith(color: primary, fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(color: primary, height: 1.6),
      bodyMedium: base.bodyMedium?.copyWith(color: secondary, height: 1.5),
      bodySmall: base.bodySmall?.copyWith(color: secondary, height: 1.5),
      labelLarge: base.labelLarge?.copyWith(color: primary, fontWeight: FontWeight.w600),
      labelMedium: base.labelMedium?.copyWith(color: secondary, fontWeight: FontWeight.w500),
      labelSmall: base.labelSmall?.copyWith(color: secondary, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  }
}
