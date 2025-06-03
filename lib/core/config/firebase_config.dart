import 'package:firebase_core/firebase_core.dart';

/// Configuración de Firebase específica para el Admin Panel Web
class FirebaseConfig {
  // Configuración para Web - Turbo Admin Panel
  // IMPORTANTE: Estas credenciales son para el entorno de producción
  // Para desarrollo, considera usar un proyecto Firebase separado
  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey: "AIzaSyAVutR13I58yvzsHjV5ZLtS9pHfe4cLsJ8",
    authDomain: "turbo-16770.firebaseapp.com",
    projectId: "turbo-16770",
    storageBucket: "turbo-16770.firebasestorage.app",
    messagingSenderId: "626963970726",
    appId: "1:626963970726:web:b87ea452393d72655a1267",
    measurementId: "G-E872L0BE36",
  );

  /// Valida que todas las configuraciones requeridas estén presentes
  static bool get isConfigurationValid {
    return webOptions.apiKey.isNotEmpty &&
        (webOptions.authDomain?.isNotEmpty ?? false) &&
        webOptions.projectId.isNotEmpty &&
        (webOptions.storageBucket?.isNotEmpty ?? false) &&
        webOptions.messagingSenderId.isNotEmpty &&
        webOptions.appId.isNotEmpty;
  }

  /// Obtiene el ID del proyecto Firebase
  static String get projectId => webOptions.projectId;

  /// Obtiene el dominio de autenticación
  static String get authDomain => webOptions.authDomain ?? '';

  // Configuración adicional para diferentes entornos si es necesario
}
