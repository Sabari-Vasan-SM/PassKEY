import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimary = Color(0xFF6366F1);
  static const Color _lightSecondary = Color(0xFF8B5CF6);
  static const Color _lightTertiary = Color(0xFFEC4899);
  static const Color _lightBackground = Color(0xFFFAFAFA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightError = Color(0xFFDC2626);

  // Dark Theme Colors
  static const Color _darkPrimary = Color(0xFF818CF8);
  static const Color _darkSecondary = Color(0xFFA78BFA);
  static const Color _darkTertiary = Color(0xFFF472B6);
  static const Color _darkBackground = Color(0xFF0F172A);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkError = Color(0xFFF87171);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        tertiary: _lightTertiary,
        background: _lightBackground,
        surface: _lightSurface,
        error: _lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onBackground: const Color(0xFF1F2937),
        onSurface: const Color(0xFF1F2937),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        tertiary: _darkTertiary,
        background: _darkBackground,
        surface: _darkSurface,
        error: _darkError,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onTertiary: Colors.black,
        onBackground: const Color(0xFFF1F5F9),
        onSurface: const Color(0xFFF1F5F9),
        onError: Colors.black,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFF1F5F9),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
    );
  }
}
