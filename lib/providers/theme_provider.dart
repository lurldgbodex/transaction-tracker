import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Mode { light, dark, system }

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'app_theme';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);

    if (saved == Mode.light.name) {
      state = ThemeMode.light;
    } else if (saved == Mode.dark.name) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    if (mode == ThemeMode.light) {
      await prefs.setString(_themeKey, Mode.light.name);
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themeKey, Mode.dark.name);
    } else {
      await prefs.setString(_themeKey, Mode.system.name);
    }

    state = mode;
  }
}
