import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'turbo_colors.dart';

/// Servicio para manejar el tema de la aplicación (Light/Dark)
class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  ThemeMode _themeMode = ThemeMode.light;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  /// Alternar entre modo claro y oscuro
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Haptic feedback para mejor UX
    HapticFeedback.lightImpact();

    notifyListeners();
  }

  /// Cambiar a modo específico
  void setTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      HapticFeedback.lightImpact();
      notifyListeners();
    }
  }

  /// Colores base para glassmorphism
  static const Color glassPrimary = Color(0xFFE53E3E);
  static const Color glassSecondary = Color(0xFFFF6B35);
  static const Color glassAccent = Color(0xFF3B82F6);
}

/// Tema claro con glassmorphism y paleta coherente
class TurboLightTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'MuseoSans',

        // Color Scheme premium basado en TurboColors
        colorScheme: ColorScheme.light(
          primary: TurboColors.primary,
          primaryContainer: TurboColors.red50,
          secondary: TurboColors.secondary,
          secondaryContainer: TurboColors.orange50,
          tertiary: TurboColors.blue500,
          tertiaryContainer: TurboColors.blue50,
          surface: Colors.white,
          onSurface: TurboColors.gray900,
          surfaceContainerHighest: TurboColors.gray50,
          outline: TurboColors.gray300,
          outlineVariant: TurboColors.gray200,
          error: TurboColors.red500,
          onError: Colors.white,
          inverseSurface: TurboColors.gray900,
          onInverseSurface: TurboColors.gray50,
        ),

        // Scaffold con gradiente coherente
        scaffoldBackgroundColor: TurboColors.gray50,

        // Configuración de AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: TurboColors.gray900,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'MuseoSans',
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: TurboColors.gray900,
            letterSpacing: -0.5,
          ),
        ),

        // Cards con glassmorphism
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: TurboColors.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),

        // Botones con paleta coherente
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            shadowColor: TurboColors.primary.withOpacity(0.3),
            backgroundColor: TurboColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'MuseoSans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),

        // Texto coherente
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w900,
            color: TurboColors.gray900,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w700,
            color: TurboColors.gray900,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w500,
            color: TurboColors.gray800,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w400,
            color: TurboColors.gray700,
          ),
          bodySmall: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w400,
            color: TurboColors.gray600,
          ),
        ),
      );
}

/// Tema oscuro con glassmorphism premium y paleta coherente
class TurboDarkTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'MuseoSans',

        // Color Scheme premium dark basado en TurboColors
        colorScheme: ColorScheme.dark(
          primary: TurboColors.primaryLight,
          primaryContainer: TurboColors.slate800,
          secondary: TurboColors.secondaryLight,
          secondaryContainer: TurboColors.slate700,
          tertiary: TurboColors.blue400,
          tertiaryContainer: TurboColors.slate800,
          surface: TurboColors.slate900,
          onSurface: TurboColors.slate50,
          surfaceContainerHighest: TurboColors.slate800,
          outline: TurboColors.slate600,
          outlineVariant: TurboColors.slate700,
          error: TurboColors.red400,
          onError: TurboColors.slate900,
          inverseSurface: TurboColors.slate50,
          onInverseSurface: TurboColors.slate900,
        ),

        // Scaffold con gradiente coherente
        scaffoldBackgroundColor: TurboColors.slate900,

        // AppBar oscura
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: TurboColors.slate50,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'MuseoSans',
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: TurboColors.slate50,
            letterSpacing: -0.5,
          ),
        ),

        // Cards con glassmorphism oscuro
        cardTheme: CardThemeData(
          elevation: 0,
          color: TurboColors.slate800.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: TurboColors.primaryLight.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),

        // Botones premium dark
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 12,
            shadowColor: TurboColors.primaryLight.withOpacity(0.4),
            backgroundColor: TurboColors.primaryLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'MuseoSans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),

        // Texto coherente dark
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w900,
            color: TurboColors.slate50,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w700,
            color: TurboColors.slate50,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w500,
            color: TurboColors.slate200,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w400,
            color: TurboColors.slate300,
          ),
          bodySmall: TextStyle(
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w400,
            color: TurboColors.slate400,
          ),
        ),
      );
}
