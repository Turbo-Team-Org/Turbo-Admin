import 'package:flutter/material.dart';
import 'package:turbo_admin/app/router/app_router.dart';
import 'package:turbo_admin/app/theme/app_theme.dart'; // Import the theme
import 'package:responsive_framework/responsive_framework.dart'; // Import responsive_framework

class TurboAdminApp extends StatelessWidget {
  const TurboAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Turbo Admin',
      debugShowCheckedModeBanner: false,
      
      routerConfig: AppRouter.router,
      
      theme: AppTheme.lightTheme, // Use the light theme
      darkTheme: AppTheme.darkTheme, // Optionally provide dark theme
      themeMode: ThemeMode.system, // Follow system preference (or set to light/dark)
      
      // Integrate ResponsiveBreakpoints.builder
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!, // The child is the MaterialApp.router itself
        breakpoints: const [
          Breakpoint(start: 0, end: 480, name: MOBILE),
          Breakpoint(start: 481, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        // Optional: defaultScale, defaultScaleFactor, etc.
      ),
    );
  }
}
