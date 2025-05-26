import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Configuración para Web - Turbo Admin Panel
  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey:
        "AIzaSyAVutR13I58yvzsHjV5ZLtS9pHfe4cLsJ8", // Reemplaza con tu API Key de web
    authDomain: "turbo-16770.firebaseapp.com",
    projectId: "turbo-16770",
    storageBucket: "turbo-16770.firebasestorage.app",
    messagingSenderId: "626963970726",
    appId: "1:626963970726:web:b87ea452393d72655a1267",
    measurementId: "G-E872L0BE36",
  );

  // Configuración adicional para diferentes entornos si es necesario
}
