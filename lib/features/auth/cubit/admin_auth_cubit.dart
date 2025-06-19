import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';
import 'package:flutter/foundation.dart';

part 'admin_auth_cubit.freezed.dart';
part 'admin_auth_state.dart';

/// Cubit unificado para manejar autenticación de admins y business owners
/// Usa el nuevo sistema de autenticación unificada del core
class AdminAuthCubit extends Cubit<AdminAuthState> with BaseCubit {
  final AdminAuthRepository _authRepository;

  AdminAuthCubit(this._authRepository) : super(const AdminAuthState.initial());

  /// Login unificado que determina automáticamente si es admin o business owner
  Future<void> signInUnified({
    required String email,
    required String password,
  }) async {
    secureEmit(const AdminAuthState.loading());

    try {
      final result = await _authRepository.signInUnified(
        email: email,
        password: password,
      );

      result.fold(
        (failure) => secureEmit(
            AdminAuthState.error(_parseAuthError(failure.toString()))),
        (authResult) => _handleAuthResult(authResult),
      );
    } catch (e) {
      secureEmit(AdminAuthState.error(_parseAuthError(e.toString())));
    }
  }

  /// Registra un nuevo business owner y crea solicitud automáticamente
  Future<void> registerAndRequestBusinessOwner({
    required String email,
    required String password,
    required String displayName,
    required String businessName,
    required String businessDescription,
    required String businessAddress,
    String? phoneNumber,
    String? website,
  }) async {
    secureEmit(const AdminAuthState.loading());

    try {
      final result = await _authRepository.registerAndRequestBusinessOwner(
        email: email,
        password: password,
        displayName: displayName,
        businessName: businessName,
        businessDescription: businessDescription,
        businessAddress: businessAddress,
        phoneNumber: phoneNumber,
        website: website,
      );

      result.fold(
        (failure) => secureEmit(
            AdminAuthState.error(_parseAuthError(failure.toString()))),
        (registrationResult) => secureEmit(
            AdminAuthState.businessOwnerRegistered(registrationResult.request)),
      );
    } catch (e) {
      secureEmit(AdminAuthState.error(_parseAuthError(e.toString())));
    }
  }

  /// Maneja el resultado de autenticación unificada
  void _handleAuthResult(AuthResult authResult) {
    switch (authResult) {
      case AuthResultAdmin(user: final adminUser):
        secureEmit(AdminAuthState.authenticatedAdmin(adminUser));
        break;
      case AuthResultBusinessOwner(request: final businessOwnerRequest):
        secureEmit(
            AdminAuthState.authenticatedBusinessOwner(businessOwnerRequest));
        break;
    }
  }

  /// Verifica el estado actual de autenticación
  Future<void> checkAuthStatus() async {
    secureEmit(const AdminAuthState.loading());

    try {
      final result = await _authRepository.getCurrentAdminUser();
      result.fold(
        (failure) => secureEmit(AdminAuthState.error(failure.toString())),
        (adminUser) {
          if (adminUser != null) {
            secureEmit(AdminAuthState.authenticatedAdmin(adminUser));
          } else {
            // Verificar si hay una sesión de business owner
            _checkBusinessOwnerSession();
          }
        },
      );
    } catch (e) {
      secureEmit(AdminAuthState.error(e.toString()));
    }
  }

  /// Verifica si hay una sesión activa de business owner
  Future<void> _checkBusinessOwnerSession() async {
    try {
      // Intentar login con business owner usando signInUnified
      // Si no hay sesión activa, simplemente marcar como no autenticado
      secureEmit(const AdminAuthState.unauthenticated());
    } catch (e) {
      secureEmit(const AdminAuthState.unauthenticated());
    }
  }

  /// Cierra sesión
  Future<void> signOut() async {
    if (kDebugMode) {
      debugPrint('🔄 AdminAuthCubit: Iniciando signOut...');
    }

    secureEmit(const AdminAuthState.loading());

    try {
      if (kDebugMode) {
        debugPrint(
            '🔄 AdminAuthCubit: Llamando a _authRepository.signOut()...');
      }

      await _authRepository.signOut();

      if (kDebugMode) {
        debugPrint(
            '✅ AdminAuthCubit: signOut exitoso, emitiendo unauthenticated');
      }

      secureEmit(const AdminAuthState.unauthenticated());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AdminAuthCubit: Error en signOut: $e');
      }
      secureEmit(AdminAuthState.error(e.toString()));
    }
  }

  /// Envía email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    secureEmit(const AdminAuthState.loading());

    try {
      await _authRepository.sendPasswordResetEmail(email);
      secureEmit(const AdminAuthState.passwordResetSent());
    } catch (e) {
      secureEmit(AdminAuthState.error(e.toString()));
    }
  }

  /// Limpia el estado de error
  void clearError() {
    if (state is AdminAuthError) {
      secureEmit(const AdminAuthState.unauthenticated());
    }
  }

  /// Obtener usuario admin actual (si está autenticado como admin)
  AdminUser? get currentAdminUser {
    if (state is AdminAuthenticatedAdmin) {
      return (state as AdminAuthenticatedAdmin).user;
    }
    return null;
  }

  /// Obtener solicitud de business owner actual (si está autenticado como business owner)
  BusinessOwnerRequest? get currentBusinessOwnerRequest {
    if (state is AdminAuthenticatedBusinessOwner) {
      return (state as AdminAuthenticatedBusinessOwner).request;
    } else if (state is AdminAuthBusinessOwnerRegistered) {
      return (state as AdminAuthBusinessOwnerRegistered).request;
    }
    return null;
  }

  /// Verificar si el usuario actual es un super admin
  bool get isSuperAdmin {
    final admin = currentAdminUser;
    return admin?.role.name == 'superAdmin';
  }

  /// Verificar si el usuario actual es un admin aprobado
  bool get isApprovedAdmin {
    return currentAdminUser != null;
  }

  /// Verificar si el usuario actual es un business owner
  bool get isBusinessOwner {
    return currentBusinessOwnerRequest != null;
  }

  /// Verificar si el business owner está aprobado
  bool get isBusinessOwnerApproved {
    final request = currentBusinessOwnerRequest;
    return request?.status == BusinessOwnerRequestStatus.approved;
  }

  /// Verificar si el business owner está pendiente
  bool get isBusinessOwnerPending {
    final request = currentBusinessOwnerRequest;
    return request?.status == BusinessOwnerRequestStatus.pending;
  }

  /// Verificar si el business owner fue rechazado
  bool get isBusinessOwnerRejected {
    final request = currentBusinessOwnerRequest;
    return request?.status == BusinessOwnerRequestStatus.rejected;
  }

  /// Obtener el motivo de rechazo si existe
  String? get businessOwnerRejectionReason {
    final request = currentBusinessOwnerRequest;
    if (request?.status == BusinessOwnerRequestStatus.rejected) {
      return request?.rejectionReason;
    }
    return null;
  }

  /// Verificar si puede manejar un lugar específico
  bool canManagePlace(String placeId) {
    // Super admin puede manejar cualquier lugar
    if (isSuperAdmin) return true;

    // Business owner aprobado puede manejar sus lugares
    // TODO: Implementar lógica cuando el core package tenga la propiedad approvedPlaceIds
    if (isBusinessOwnerApproved) {
      return true; // Por ahora permitir acceso a business owners aprobados
    }

    return false;
  }

  /// Obtener lugares que puede administrar
  List<String> get manageablePlaceIds {
    // Super admin puede manejar todos (retornar lista vacía significa "todos")
    if (isSuperAdmin) return [];

    // Business owner aprobado puede manejar sus lugares específicos
    // TODO: Implementar cuando el core package tenga la propiedad approvedPlaceIds
    if (isBusinessOwnerApproved) {
      return []; // Por ahora retornar lista vacía (acceso a todos)
    }

    return [];
  }

  /// TEMPORAL: Verificar permisos de administrador
  /// En futuro, esto debería consultar colección admin_users en Firestore
  Future<bool> _verifyAdminPermissions(AuthUser user) async {
    try {
      // TEMPORAL: Lista expandida de emails de administradores para desarrollo
      const adminEmails = [
        'dmwhispers551@gmail.com',
        'alea@gmail.com',
        'admin@turbo.com',
        'david@turbo.com',
        'test@admin.com',
        'lugar@admin.com',
        'demo@turbo.com',
        'admin@demo.com',
        'owner@lugar.com',
        'dueño@lugar.com',
      ];

      // Verificación temporal por email
      if (adminEmails.contains(user.email.toLowerCase())) {
        return true;
      }

      // TODO: Para desarrollo, también permitir emails que terminen en @turbo.com
      if (user.email.toLowerCase().endsWith('@turbo.com')) {
        return true;
      }

      // TODO: Implementar verificación real consultando Firestore
      // final adminDoc = await FirebaseFirestore.instance
      //     .collection('admin_users')
      //     .doc(user.uid)
      //     .get();
      //
      // return adminDoc.exists && adminDoc.data()?['isActive'] == true;

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Actualiza los lugares que administra un usuario
  Future<void> updateOwnedPlaces(List<String> ownedPlaceIds) async {
    secureEmit(const AdminAuthState.loading());

    try {
      final currentAdmin = currentAdminUser;
      if (currentAdmin == null) {
        throw Exception('No hay un administrador autenticado');
      }

      await _authRepository.updateOwnedPlaces(currentAdmin.uid, ownedPlaceIds);

      // Actualizar el estado con los nuevos ownedPlaceIds
      secureEmit(AdminAuthState.authenticatedAdmin(
        currentAdmin.copyWith(ownedPlaceIds: ownedPlaceIds),
      ));
    } catch (e) {
      secureEmit(AdminAuthState.error(e.toString()));
    }
  }

  /// Convierte errores de Firebase a mensajes amigables
  String _parseAuthError(String error) {
    if (error.contains('user-not-found')) {
      return 'Usuario no encontrado';
    } else if (error.contains('wrong-password')) {
      return 'Contraseña incorrecta';
    } else if (error.contains('email-already-in-use')) {
      return 'El email ya está registrado';
    } else if (error.contains('weak-password')) {
      return 'La contraseña es muy débil';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido';
    } else if (error.contains('too-many-requests')) {
      return 'Demasiados intentos. Intenta más tarde';
    } else if (error.contains('network-request-failed')) {
      return 'Error de conexión. Verifica tu internet';
    }
    return 'Error de autenticación: $error';
  }
}
