import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: Colors.teal.shade600,
      secondary: Colors.indigo.shade400,
      surface: const Color(0xFFF9FAFb),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF1E293B),
      error: Colors.red.shade400,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF475569)),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal.shade400,
      secondary: Colors.indigo.shade300,
      surface: const Color(0xFF121212),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: const Color(0xFFE5E7EB),
      error: Colors.red.shade300,
      onError: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE5E7EB)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
