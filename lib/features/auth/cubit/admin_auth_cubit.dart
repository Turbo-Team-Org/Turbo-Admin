import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';

part 'admin_auth_cubit.freezed.dart';
part 'admin_auth_state.dart';

/// Cubit temporal para manejar autenticación de administradores de lugares
/// hasta que el core implemente AdminAuthRepository
class AdminAuthCubit extends Cubit<AdminAuthState> with BaseCubit {
  final AdminAuthRepository _authRepository;

  AdminAuthCubit(this._authRepository) : super(const AdminAuthState.initial());

  /// Inicia sesión específicamente para administradores de lugares
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    secureEmit(const AdminAuthState.loading());

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.fold(
        (l) => secureEmit(AdminAuthState.error(l.toString())),
        (user) => secureEmit(AdminAuthState.authenticated(user)),
      );
    } catch (e) {
      secureEmit(AdminAuthState.error(e.toString()));
    }
  }

  /// Registra un nuevo administrador de lugar
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    List<String> ownedPlaceIds = const [],
  }) async {
    secureEmit(const AdminAuthState.loading());

    try {
      final response = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        ownedPlaceIds: ownedPlaceIds,
      );
      response.fold(
        (l) => secureEmit(AdminAuthState.error(l.toString())),
        (user) => secureEmit(AdminAuthState.authenticated(user)),
      );
    } catch (e) {
      secureEmit(AdminAuthState.error(_parseAuthError(e.toString())));
    }
  }

  /// Cierra sesión
  Future<void> signOut() async {
    secureEmit(const AdminAuthState.loading());

    try {
      await _authRepository.signOut();
      secureEmit(const AdminAuthState.unauthenticated());
    } catch (e) {
      secureEmit(AdminAuthState.error(e.toString()));
    }
  }

  /// Verifica el estado actual de autenticación
  Future<void> checkAuthStatus() async {
    secureEmit(const AdminAuthState.loading());

    try {
      final user = await _authRepository.getCurrentAdminUser();
      user.fold(
        (l) => secureEmit(AdminAuthState.error(l.toString())),
        (user) {
          if (user == null) {
            secureEmit(const AdminAuthState.unauthenticated());
          } else {
            secureEmit(AdminAuthState.authenticated(user));
          }
        },
      );
    } catch (e) {
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

  /// Obtener usuario admin actual (si está autenticado)
  AdminUser? get currentAdminUser {
    if (state is AdminAuthAuthenticated) {
      return (state as AdminAuthAuthenticated).user;
    }
    return null;
  }

  /// Verificar si puede manejar un lugar específico
  bool canManagePlace(String placeId) {
    final admin = currentAdminUser;
    if (admin == null) return false;

    // Super admin puede manejar cualquier lugar
    if (admin.role.name == 'super_admin') return true;

    // Verificar ownership
    return admin.ownedPlaceIds.contains(placeId);
  }

  /// Obtener lugares que puede administrar
  List<String> get manageablePlaceIds {
    final admin = currentAdminUser;
    if (admin == null) return [];

    return admin.ownedPlaceIds;
  }

  /// TEMPORAL: Verificar permisos de administrador
  /// En futuro, esto debería consultar colección admin_users en Firestore
  Future<bool> _verifyAdminPermissions(AuthUser user) async {
    try {
      // TEMPORAL: Lista expandida de emails de administradores para desarrollo
      const adminEmails = [
        'dmwhispers551@gmail.com',
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

  /// Convertir errores de Firebase a mensajes amigables
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
    }
    return 'Error de autenticación: $error';
  }
}
