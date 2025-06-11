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

  /// Estado de registro de propietario
  const factory AdminAuthState.registeringBusinessOwner(
      BusinessOwnerRegistrationResult user) = AdminAuthRegisteringBusinessOwner;

  /// Estado de registro de administrador
  const factory AdminAuthState.loginBusinessOwner(BusinessOwnerRequest user) =
      AdminAuthLoginBusinessOwner;

  /// Usuario no autenticado
  const factory AdminAuthState.unauthenticated() = AdminAuthUnauthenticated;

  /// Error de autenticación
  const factory AdminAuthState.error(String message) = AdminAuthError;

  /// Email de recuperación enviado
  const factory AdminAuthState.passwordResetSent() = AdminAuthPasswordResetSent;
}
