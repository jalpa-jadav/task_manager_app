import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = Hive.box('settings');
    final themeMode = box.get('themeMode', defaultValue: ThemeMode.light);
    state = themeMode;
  }

  Future<void> toggleTheme() async {
    final box = Hive.box('settings');
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await box.put('themeMode', ThemeMode.dark);
    } else {
      state = ThemeMode.light;
      await box.put('themeMode', ThemeMode.light);
    }
  }
}
