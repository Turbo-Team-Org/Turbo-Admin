import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For User model, UserRepository, UserService, Role model (if exists)

// --- UserManagement States ---
abstract class UserManagementState {}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

// State when a user's data is loaded for management/editing
class UserManagementLoaded extends UserManagementState {
  final AuthUser user;
  // final List<Role> availableRoles; // If roles are dynamic and selectable

  UserManagementLoaded({
    required this.user,
    // required this.availableRoles,
  });
}

// State after an update action is successful
class UserManagementSuccess extends UserManagementState {
  final String message;
  UserManagementSuccess(this.message);
}

class UserManagementError extends UserManagementState {
  final String message;
  UserManagementError(this.message);
}

// --- UserManagement Cubit ---
class UserManagementCubit extends Cubit<UserManagementState> {
  final AuthenticationRepository _userRepository;

  // final RoleRepository _roleRepository; // If roles are fetched from a repository

  UserManagementCubit({
    required AuthenticationRepository userRepository,

    // RoleRepository? roleRepository,
  })  : _userRepository = userRepository,

        // _roleRepository = roleRepository ?? GetIt.instance<RoleRepository>(),
        super(UserManagementInitial());

  Future<void> loadUserForManagement(String userId) async {
    emit(UserManagementLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      // final availableRoles = await _roleRepository.getRoles(); // Example

      if (user != null) {
        emit(UserManagementLoaded(
          user: user,
          // availableRoles: availableRoles,
        ));
      } else {
        emit(UserManagementError('Usuario no encontrado.'));
      }
    } catch (e) {
      emit(UserManagementError(e.toString()));
    }
  }
/*
  Future<void> updateUserProfile(String userId, UserProfileUpdateData data) async {
    // UserProfileUpdateData would be a simple class/record holding fields that can be updated
    // e.g., name, email (if changeable), custom profile fields.
    emit(UserManagementLoading());
    try {
      await _userService.updateUserProfile(userId, data);
      emit(UserManagementSuccess('Perfil de usuario actualizado.'));
      // Optionally reload user data
      await loadUserForManagement(userId);
    } catch (e) {
      emit(UserManagementError('Error al actualizar perfil: ${e.toString()}'));
    }
  }

  Future<void> updateUserRole(String userId, String newRoleId) async {
    emit(UserManagementLoading());
    try {
      // Assuming UserService has a method to change a user's role
      await _userService.updateUserRole(userId, newRoleId);
      emit(UserManagementSuccess('Rol de usuario actualizado.'));
      await loadUserForManagement(userId); // Reload to show new role
    } catch (e) {
      emit(UserManagementError('Error al actualizar rol: ${e.toString()}'));
    }
  }
  
  Future<void> updateUserStatus(String userId, bool isActive) async {
    emit(UserManagementLoading());
    try {
      await _userService.updateUserStatus(userId, isActive);
      emit(UserManagementSuccess(isActive ? 'Usuario activado.' : 'Usuario desactivado.'));
      await loadUserForManagement(userId); // Reload to show new status
    } catch (e) {
      emit(UserManagementError('Error al actualizar estado: ${e.toString()}'));
    }
  }
  */
}

// Example Data Transfer Object for profile updates (not from core)
class UserProfileUpdateData {
  final String? name;
  final String? email; // If applicable
  // Add other editable fields

  UserProfileUpdateData({this.name, this.email});
}
