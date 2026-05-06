import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/core/widgets/data_tables/users_data_table.dart';
import 'package:turbo_admin/features/users/cubit/users_cubit.dart';
import 'package:get_it/get_it.dart';
// import 'package:core/core.dart'; // For models if needed directly

class PlaceholderUsersListPage extends StatelessWidget {
  const PlaceholderUsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<UsersCubit>(),
      child: AdminPage(
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersLoaded) {
              return UsersDataTable(
                  users: state.users,
                  onEdit: (userId) => context.goNamed('manageUser',
                      pathParameters: {'userId': userId}),
                  onDelete: (userId) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("Confirmar Eliminación"),
                              content: const Text(
                                  "¿Seguro que quieres eliminar este usuario? Esta acción puede ser irreversible."),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancelar")),
                                TextButton(
                                    onPressed: () {
                                      //        context
                                      //             .read<UsersCubit>()
                                      //             .deleteUser(userId);
                                      //         Navigator.pop(context);
                                    },
                                    child: const Text(
                                        'Eliminar',
                                        style:
                                            TextStyle(color: Colors.red)))
                              ],
                            ));
                  },
                  onUpdateStatus: (userId, newStatus) {
                    //         context.read<UsersCubit>().updateUserStatus(userId, newStatus);
                  },
                  onRefresh: () => {} // context.read<UsersCubit>().loadUsers(),
                  // onUpdateRole: (userId, newRole) { // If direct role change from table is needed
                  //   context.read<UsersCubit>().updateUserRole(userId, newRole);
                  // },
                  );
            } else if (state is UsersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error cargando usuarios',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      // onPressed: () => context.read<UsersCubit>().loadUsers(),

                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Estado inicial'));
            }
          },
        ),
      ),
    );
  }
}
