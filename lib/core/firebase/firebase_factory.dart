import 'package:firebase_core/firebase_core.dart';
import '../config/firebase_config.dart';

/// Factory para inicializar Firebase específicamente para Web Admin Panel
class FirebaseFactory {
  static Future<FirebaseApp> initializeApp() async {
    try {
      // Configuración específica para Web Admin Panel
      return await Firebase.initializeApp(
        options: FirebaseConfig.webOptions,
      );
    } catch (e) {
      // Si Firebase ya está inicializado, devolver la instancia existente
      if (e.toString().contains('already exists')) {
        return Firebase.app();
      }
      rethrow;
    }
  }

  /// Verifica si Firebase está inicializado
  static bool get isInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }
}
