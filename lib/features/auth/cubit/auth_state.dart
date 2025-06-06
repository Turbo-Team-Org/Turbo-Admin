part of 'auth_cubit.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Estado inicial
  const factory AuthState.initial() = AuthInitial;

  /// Estado de carga
  const factory AuthState.loading() = AuthLoading;

  /// Usuario autenticado
  const factory AuthState.authenticated(AdminUser user) = AuthAuthenticated;

  /// Usuario no autenticado
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// Error de autenticación
  const factory AuthState.error(String message) = AuthError;

  /// Email de recuperación enviado
  const factory AuthState.passwordResetSent() = AuthPasswordResetSent;
}
