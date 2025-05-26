import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';

class FirebaseFactory {
  static Future<FirebaseApp> initializeApp() async {
    if (kIsWeb) {
      // Configuración específica para Web Admin Panel
      return await Firebase.initializeApp(
        options: FirebaseConfig.webOptions,
      );
    } else {
      // Para móvil usa firebase_options.dart generado por FlutterFire CLI
      // Este archivo se genera automáticamente y maneja iOS/Android
      // Importa: import 'firebase_options.dart';
      // return await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      return await Firebase.initializeApp();
    }
  }
}
