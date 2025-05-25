import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple, // Primary color seed
        brightness: Brightness.light,
      ),
      // Example of further customization
      appBarTheme: const AppBarTheme(
        elevation: 0.5,
        // backgroundColor: Colors.white, // Or from colorScheme
        // foregroundColor: Colors.black, // Or from colorScheme
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.grey[100], // Slightly off-white for the rail
        indicatorColor: Colors.deepPurple.shade100, // Color for selected item indicator
        selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade800),
        unselectedIconTheme: IconThemeData(color: Colors.grey.shade600),
        selectedLabelTextStyle: TextStyle(color: Colors.deepPurple.shade800, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: TextStyle(color: Colors.grey.shade700),
      ),
      // Define other component themes as needed (buttons, cards, dialogs, etc.)
      // cardTheme: CardTheme(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      // elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(...)),
      
      // Glassmorphism is tricky and often done per-widget with BackdropFilter and BoxDecoration.
      // It's not typically a global theme setting.
    );
  }

  // Optionally, define a darkTheme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      // Customize dark theme components
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.grey[850], 
        indicatorColor: Colors.deepPurple.shade700,
        selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade200),
        unselectedIconTheme: IconThemeData(color: Colors.grey.shade400),
        selectedLabelTextStyle: TextStyle(color: Colors.deepPurple.shade200, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }
}
