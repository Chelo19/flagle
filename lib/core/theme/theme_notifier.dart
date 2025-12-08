import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    if (value == ThemeMode.light) {
      value = ThemeMode.dark;
    } else {
      value = ThemeMode.light;
    }
  }

  void setTheme(ThemeMode mode) {
    value = mode;
  }

  bool get isDarkMode {
    return value == ThemeMode.dark;
  }
}

