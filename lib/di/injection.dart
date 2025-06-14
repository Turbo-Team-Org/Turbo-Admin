import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_admin/core/firebase/firebase_factory.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';
import 'package:turbo_admin/features/events/cubit/events_cubit.dart';
import 'package:turbo_admin/features/events/cubit/event_form_cubit.dart';
import 'package:turbo_admin/features/reviews/cubit/reviews_cubit.dart';
import 'package:turbo_admin/features/reviews/cubit/review_moderation_cubit.dart';
import 'package:turbo_admin/features/categories/cubit/categories_cubit.dart';
import 'package:turbo_admin/features/categories/cubit/category_form_cubit.dart';
import 'package:turbo_admin/features/users/cubit/users_cubit.dart';
import 'package:turbo_admin/features/users/cubit/user_management_cubit.dart';
import 'package:turbo_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as dashboard_cubit;
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:turbo_admin/features/business_requests/cubit/business_requests_cubit.dart';

/// Inicializa todas las dependencias específicas del UI del Admin Panel
Future<void> initUIDependencies() async {
  final di = GetIt.instance;

  try {
    debugPrint('🔄 Iniciando configuración de dependencias del Admin Panel...');

    // Verificar que Firebase esté inicializado
    if (!FirebaseFactory.isInitialized) {
      throw Exception(
          'Firebase debe estar inicializado antes de configurar las dependencias');
    }
    debugPrint('✅ Firebase verificado como inicializado');

    // Obtener la instancia de Firebase App
    final firebaseApp = await FirebaseFactory.initializeApp();
    debugPrint('✅ Firebase App obtenido: ${firebaseApp.name}');

    // Inicializar dependencias del core (repositorios, servicios, etc.)
    debugPrint('🔄 Inicializando dependencias del core...');
    await initCoreDependencies(sl: di, firebaseApp: firebaseApp);
    debugPrint('✅ Dependencias del core inicializadas');

    // Verificar que los repositorios estén registrados
    _verifyCoreDependencies(di);

    // Registrar Cubits para manejo de estado de UI
    debugPrint('🔄 Registrando Cubits del Admin Panel...');
    _registerUICubits(di);
    debugPrint('✅ Todos los Cubits registrados exitosamente');

    // Registrar Dashboard
    _registerDashboardCubit(di);

    debugPrint('🎉 Inicialización del Admin Panel completada exitosamente');
    debugPrint('✅ Sistema de autenticación para administradores ACTIVADO');
  } catch (e, stackTrace) {
    debugPrint('❌ Error durante la inicialización de dependencias: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    rethrow;
  }
}

/// Verifica que las dependencias del core estén correctamente registradas
void _verifyCoreDependencies(GetIt di) {
  final requiredDependencies = [
    'PlaceRepository',
    'EventRepository',
    'ReviewRepository',
    'CategoryRepository',
    'AuthenticationRepository',
    'AdminAuthRepository',
  ];

  for (final dependency in requiredDependencies) {
    try {
      switch (dependency) {
        case 'PlaceRepository':
          di<PlaceRepository>();
          break;
        case 'EventRepository':
          di<EventRepository>();
          break;
        case 'ReviewRepository':
          di<ReviewRepository>();
          break;
        case 'CategoryRepository':
          di<CategoryRepository>();
          break;
        case 'AuthenticationRepository':
          di<AuthenticationRepository>();
          break;
        case 'AdminAuthRepository':
          di<AdminAuthRepository>();
          break;
      }
      debugPrint('✅ $dependency registrado correctamente');
    } catch (e) {
      debugPrint('❌ $dependency NO está registrado: $e');
      throw Exception('Dependencia requerida no encontrada: $dependency');
    }
  }
}

/// Registra todos los Cubits del UI
void _registerUICubits(GetIt di) {
  // Sistema de autenticación unificado - maneja admins y business owners
  di.registerLazySingleton(() {
    final cubit = AdminAuthCubit(di<AdminAuthRepository>());
    // Inicializar verificación de estado en cuanto se crea
    Future.microtask(() => cubit.checkAuthStatus());
    return cubit;
  });
  debugPrint(
      '✅ AdminAuthCubit registrado - Sistema de autenticación UNIFICADO ACTIVADO');

  // Gestión de Lugares
  di.registerLazySingleton(() => PlaceFormCubit(
        placeRepository: di<PlaceRepository>(),
        categoryRepository: di<CategoryRepository>(),
      ));
  debugPrint('✅ PlaceFormCubit registrado');

  di.registerLazySingleton(() => PlacesCubit(
        placeRepository: di<PlaceRepository>(),
        placeFormCubit: di<PlaceFormCubit>(),
      ));
  debugPrint('✅ PlacesCubit registrado');

  // Gestión de Eventos
  di.registerLazySingleton(() => EventsCubit(
        eventRepository: di<EventRepository>(),
      ));
  debugPrint('✅ EventsCubit registrado');

  di.registerLazySingleton(() => EventFormCubit(
        eventRepository: di<EventRepository>(),
        placeRepository: di<PlaceRepository>(),
      ));
  debugPrint('✅ EventFormCubit registrado');

  // Gestión de Reseñas y Moderación
  di.registerLazySingleton(() => ReviewsCubit(
        reviewRepository: di<ReviewRepository>(),
      ));
  debugPrint('✅ ReviewsCubit registrado');

  di.registerLazySingleton(() => ReviewModerationCubit(
        reviewRepository: di<ReviewRepository>(),
      ));
  debugPrint('✅ ReviewModerationCubit registrado');

  // Gestión de Categorías
  di.registerLazySingleton(() => CategoriesCubit(
        categoryRepository: di<CategoryRepository>(),
      ));
  debugPrint('✅ CategoriesCubit registrado');

  di.registerLazySingleton(() => CategoryFormCubit(
        categoryRepository: di<CategoryRepository>(),
      ));
  debugPrint('✅ CategoryFormCubit registrado');

  // Gestión de Usuarios
  di.registerLazySingleton(() => UsersCubit(
        userRepository: di<AuthenticationRepository>(),
      ));
  debugPrint('✅ UsersCubit registrado');

  di.registerLazySingleton(() => UserManagementCubit(
        userRepository: di<AuthenticationRepository>(),
      ));
  debugPrint('✅ UserManagementCubit registrado');

  // Gestión de Solicitudes de Business Owners (solo para super admins)
  di.registerLazySingleton(() => BusinessRequestsCubit(
        di<AdminAuthRepository>(),
      ));
  debugPrint('✅ BusinessRequestsCubit registrado');
}

void _registerDashboardCubit(GetIt di) {
  // Dashboard Cubit simplificado usando repositorios del core
  di.registerFactory(() => dashboard_cubit.DashboardCubit(
        placeRepository: di<PlaceRepository>(),
        eventRepository: di<EventRepository>(),
        reviewRepository: di<ReviewRepository>(),
        categoryRepository: di<CategoryRepository>(),
      ));

  debugPrint('✅ DashboardCubit registrado');
}
