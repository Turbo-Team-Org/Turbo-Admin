part of 'admin_auth_cubit.dart';

@freezed
sealed class AdminAuthState with _$AdminAuthState {
  /// Estado inicial
  const factory AdminAuthState.initial() = AdminAuthInitial;

  /// Estado de carga
  const factory AdminAuthState.loading() = AdminAuthLoading;

  /// Super Admin o Admin aprobado autenticado
  const factory AdminAuthState.authenticatedAdmin(AdminUser user) =
      AdminAuthenticatedAdmin;

  /// Business Owner autenticado (con su solicitud y estado)
  const factory AdminAuthState.authenticatedBusinessOwner(
      BusinessOwnerRequest request) = AdminAuthenticatedBusinessOwner;

  /// Business Owner registrado exitosamente
  const factory AdminAuthState.businessOwnerRegistered(
      BusinessOwnerRequest request) = AdminAuthBusinessOwnerRegistered;

  /// Usuario no autenticado
  const factory AdminAuthState.unauthenticated() = AdminAuthUnauthenticated;

  /// Error de autenticación
  const factory AdminAuthState.error(String message) = AdminAuthError;

  /// Email de recuperación enviado
  const factory AdminAuthState.passwordResetSent() = AdminAuthPasswordResetSent;
}
