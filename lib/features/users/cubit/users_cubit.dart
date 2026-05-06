import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

// --- Users States ---
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<AuthUser> users;
  final int totalCount; // For pagination
  final int currentPage; // For pagination

  UsersLoaded({
    required this.users,
    required this.totalCount,
    required this.currentPage,
  });
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}

// --- Users Cubit ---
class UsersCubit extends Cubit<UsersState> {
  // Reservado para loadUsers / paginación cuando se descomente el cuerpo del cubit.
  // ignore: unused_field
  final AuthenticationRepository _userRepository;

  UsersCubit({
    required AuthenticationRepository userRepository,
  })  : _userRepository = userRepository,
        super(UsersInitial());
/*
  Future<void> loadUsers({
    int page = 1, 
    int limit = 20, 
    String? role, // Example filter: user role
    bool? isActive, // Example filter: user status
  }) async {
    emit(UsersLoading());
    try {
      // Assuming UserRepository.getUsers() supports pagination and filtering
      final PagedResult<AuthUser> pagedResult = await _userRepository.getAllUsers(
        page: page, 
        limit: limit,
        role: role,
        isActive: isActive,
      );

      emit(UsersLoaded(
        users: pagedResult.items,
        totalCount: pagedResult.totalCount,
        currentPage: pagedResult.currentPage,
      ));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _userService.deleteUser(userId);
      // Refresh the list. Consider current filters and page.
      // For simplicity, calling loadUsers() which might reset.
      await loadUsers(); 
    } catch (e) {
      emit(UsersError('Error al eliminar usuario: ${e.toString()}'));
      // Optionally re-emit current data if state was UsersLoaded
    }
  }
  
  // Example: Method to change user status (ban/unban or activate/deactivate)
  Future<void> updateUserStatus(String userId, bool newStatus) async {
    try {
        // Assuming UserService has a method like this
        await _userService.updateUserStatus(userId, newStatus); 
        await loadUsers(); // Refresh to show updated status
    } catch (e) {
        emit(UsersError('Error al actualizar estado del usuario: ${e.toString()}'));
    }
  }
  */
}
