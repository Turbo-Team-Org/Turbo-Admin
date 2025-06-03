import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

/// Cubit para manejar el estado de autenticación
class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState.initial());

  /// Inicia sesión con email y contraseña
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());

    try {
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Registra un nuevo usuario con email y contraseña
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(const AuthState.loading());

    try {
      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Cierra sesión
  Future<void> signOut() async {
    emit(const AuthState.loading());

    try {
      await _authRepository.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Verifica el estado actual de autenticación
  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());

    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Envía email de recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    emit(const AuthState.loading());

    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      emit(const AuthState.passwordResetSent());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Limpia el estado de error
  void clearError() {
    if (state is AuthError) {
      emit(const AuthState.unauthenticated());
    }
  }
}
