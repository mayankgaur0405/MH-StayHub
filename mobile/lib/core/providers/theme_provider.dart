import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferences (nullable to handle init failure)
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  return null;
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;
  static const _themeKey = 'app_theme_mode';

  ThemeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences? prefs) {
    if (prefs == null) return ThemeMode.system;
    final savedMode = prefs.getString(_themeKey);
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    return ThemeMode.system; // Default
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      // If system, switch to the opposite of current brightness
      // For simplicity here, just toggle to dark.
      setTheme(ThemeMode.dark);
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _prefs?.setString(_themeKey, mode.name);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
