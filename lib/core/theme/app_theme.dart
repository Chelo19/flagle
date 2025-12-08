import 'package:flutter/material.dart';

class AppTheme {
  // Color principal de la app
  static const Color primaryColor = Color.fromARGB(255, 15, 148, 48);
  static const Color onPrimaryColor = Color.fromARGB(255, 225, 252, 233);
  static const Color secondaryColor = Color.fromARGB(255, 146, 240, 154);
  static const Color onSecondaryColor = Color.fromARGB(255, 2, 80, 26);

  // Tema claro
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  // Tema oscuro
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
