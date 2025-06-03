import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// Assuming 'core' is the name of your turbo_core package
// and it has an init.dart or similar for initialization.
// Adjust the import if your turbo_core package structure is different.
import 'package:core/core.dart';
import 'package:turbo_admin/app/app.dart';
import 'package:turbo_admin/di/injection.dart'; // For initUIDependencies
import 'package:turbo_admin/core/firebase/firebase_factory.dart';
import 'package:turbo_admin/core/widgets/firebase_loading_widget.dart';
import 'package:turbo_admin/core/theme/theme_service.dart';
import 'package:turbo_admin/app/router/app_router.dart';

/// Instancia global de GetIt para inyección de dependencias
final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🔥 Inicializando Firebase...');
    await FirebaseFactory.initializeApp();
    debugPrint('✅ Firebase inicializado exitosamente');

    debugPrint('🔄 Configurando dependencias...');
    await initUIDependencies();
    debugPrint('✅ Dependencias configuradas exitosamente');

    debugPrint('🚀 Iniciando Turbo Admin Panel...');
    runApp(const TurboAdminApp());
  } catch (e, stackTrace) {
    debugPrint('❌ Error durante la inicialización: $e');
    debugPrint('📍 StackTrace: $stackTrace');

    // En caso de error, mostrar una app básica con información del error
    runApp(MaterialApp(
      title: 'Turbo Admin - Error',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Error de Inicialización',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No se pudo inicializar la aplicación:\n$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => main(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class TurboAdminApp extends StatelessWidget {
  const TurboAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService(),
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Turbo Admin Panel',
          debugShowCheckedModeBanner: false,

          // Sistema de temas dual premium
          theme: TurboLightTheme.theme,
          darkTheme: TurboDarkTheme.theme,
          themeMode: ThemeService().themeMode,

          // Router con transiciones suaves y autenticación integrada
          routerConfig: AppRouter.router,

          // Builder para manejar tema con transiciones suaves
          builder: (context, child) {
            return AnimatedTheme(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              data: Theme.of(context),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
