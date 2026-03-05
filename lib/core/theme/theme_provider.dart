import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:to_do/core/storage/storage_service.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final _storage = ThemeStorageService.instance;

  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _storage.getThemeMode();

    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await _storage.saveThemeMode(state == ThemeMode.dark ? 'dark' : 'light');
  }
}
