part of 'admin_auth_cubit.dart';

@freezed
sealed class AdminAuthState with _$AdminAuthState {
  /// Estado inicial
  const factory AdminAuthState.initial() = AdminAuthInitial;

  /// Estado de carga
  const factory AdminAuthState.loading() = AdminAuthLoading;

  /// Administrador autenticado
  const factory AdminAuthState.authenticated(AdminUser user) =
      AdminAuthAuthenticated;

  /// Usuario no autenticado
  const factory AdminAuthState.unauthenticated() = AdminAuthUnauthenticated;

  /// Error de autenticación
  const factory AdminAuthState.error(String message) = AdminAuthError;

  /// Email de recuperación enviado
  const factory AdminAuthState.passwordResetSent() = AdminAuthPasswordResetSent;
}
