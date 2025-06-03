import 'package:flutter/material.dart';

class AppTheme {
  // Colores de Turbo
  static const Color turboRed = Color(0xFFE53E3E);
  static const Color turboOrange = Color(0xFFFF6B35);
  static const Color turboBackground = Color(0xFFF9FAFB);
  static const Color turboSecondary = Color(0xFF6B7280);
  static const Color turboSuccess = Color(0xFF10B981);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'MuseoSans', // Fuente personalizada
      colorScheme: ColorScheme.fromSeed(
        seedColor: turboRed,
        brightness: Brightness.light,
        primary: turboRed,
        secondary: turboOrange,
        surface: turboBackground,
      ),

      // Configuración de texto con MuseoSans
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        displayMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        displaySmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        headlineLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        headlineMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        headlineSmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        titleLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        titleMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        bodyLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w300),
        bodyMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w300),
        bodySmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w300),
        labelLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        labelMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        labelSmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
      ),

      // AppBar con tema de Turbo
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF111827),
        titleTextStyle: TextStyle(
          fontFamily: 'MuseoSans',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Color(0xFF111827),
        ),
      ),

      // NavigationRail con tema de Turbo
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.white,
        indicatorColor: turboRed.withOpacity(0.1),
        selectedIconTheme: const IconThemeData(color: turboRed),
        unselectedIconTheme: IconThemeData(color: turboSecondary),
        selectedLabelTextStyle: const TextStyle(
          fontFamily: 'MuseoSans',
          color: turboRed,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: const TextStyle(
          fontFamily: 'MuseoSans',
          color: turboSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ElevatedButton con tema de Turbo
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: turboRed,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // InputDecoration con tema de Turbo
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: turboRed, width: 2),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'MuseoSans',
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'MuseoSans',
          fontWeight: FontWeight.w300,
        ),
      ),

      // Card con tema de Turbo
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
    );
  }

  // Tema oscuro para Turbo
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'MuseoSans',
      colorScheme: ColorScheme.fromSeed(
        seedColor: turboRed,
        brightness: Brightness.dark,
        primary: turboRed,
        secondary: turboOrange,
      ),
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        displayMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        displaySmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        headlineLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        headlineMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w700),
        headlineSmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        titleLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        titleMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        bodyLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w300),
        bodyMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w300),
        bodySmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w300),
        labelLarge:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        labelMedium:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
        labelSmall:
            TextStyle(fontFamily: 'MuseoSans', fontWeight: FontWeight.w500),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color(0xFF1F2937),
        indicatorColor: turboRed.withOpacity(0.2),
        selectedIconTheme: const IconThemeData(color: turboRed),
        unselectedIconTheme: IconThemeData(color: Colors.grey.shade400),
        selectedLabelTextStyle: const TextStyle(
          fontFamily: 'MuseoSans',
          color: turboRed,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontFamily: 'MuseoSans',
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
