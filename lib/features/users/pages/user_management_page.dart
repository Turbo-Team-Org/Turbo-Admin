import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/users/cubit/user_management_cubit.dart';
import 'package:core/core.dart'; // For User model, UserProfileUpdateData, potentially Role model

class UserManagementPage extends StatelessWidget {
  final String userId;

  const UserManagementPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<UserManagementCubit>()..loadUserForManagement(userId),
      child: AdminPage(
        body: BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            if (state is UserManagementLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserManagementLoaded) {
              return const Center(
                child: Text('Gestión de usuario (placeholder)'),
              );
            } else if (state is UserManagementError) {
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
                      'Error cargando usuario',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<UserManagementCubit>()
                          .loadUserForManagement(userId),
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

// class UserManagementPage extends StatefulWidget {
//   final String userId;

//   const UserManagementPage({super.key, required this.userId});

//   @override
//   State<UserManagementPage> createState() => _UserManagementPageState();
// }

// class _UserManagementPageState extends State<UserManagementPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _displayNameController;
//   late TextEditingController _emailController;

//   String?
//       _selectedRole; // Assuming roles are strings for now. Could be Role objects.
//   bool _isActive = true;

//   // Example list of roles - in a real app, this might come from UserManagementLoaded state via RoleRepository
//   final List<String> _availableRoles = ['admin', 'editor', 'viewer', 'user'];

//   @override
//   void initState() {
//     super.initState();
//     _displayNameController = TextEditingController();
//     _emailController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _displayNameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _initializeFields(AuthUser user) {
//     _displayNameController.text = user.displayName ?? '';
//     _emailController.text =
//         user.email; // Email usually not editable from admin panel directly
//     //  _selectedRole = user.role; // Assuming User model has a 'role' string field
//     //  _isActive = user.isActive;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GetIt.instance<UserManagementCubit>()
//         ..loadUserForManagement(widget.userId),
//       child: AdminScaffold(
//         title: 'Gestionar Usuario',
//         body: BlocConsumer<UserManagementCubit, UserManagementState>(
//           listener: (context, state) {
//             if (state is UserManagementSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text(state.message),
//                     backgroundColor: Colors.green),
//               );
//               // Optionally pop or refresh data by re-calling loadUserForManagement
//               // context.read<UserManagementCubit>().loadUserForManagement(widget.userId);
//             } else if (state is UserManagementError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text('Error: ${state.message}'),
//                     backgroundColor: Colors.red),
//               );
//             } else if (state is UserManagementLoaded) {
//               _initializeFields(state.user);
//             }
//           },
//           builder: (context, state) {
//             if (state is UserManagementLoading ||
//                 state is UserManagementInitial) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is UserManagementLoaded) {
//               final user = state.user;
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     _buildUserDetailsCard(context, user),
//                     const SizedBox(height: 24),
//                     _buildUserManagementForm(context, user),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.arrow_back),
//                       label: Text("Volver a la lista"),
//                       onPressed: () => context.pop(),
//                     )
//                   ],
//                 ),
//               );
//             }
//             if (state is UserManagementSuccess) {
//               // Show success message and stay or allow nav
//               return Center(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green, size: 50),
//                   SizedBox(height: 10),
//                   Text(state.message),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                       child: Text("Ok"),
//                       onPressed: () {
//                         if (context.canPop()) context.pop();
//                       })
//                 ],
//               ));
//             }

//             return Center(
//                 child: Text(
//                     'Error al cargar datos del usuario: ${widget.userId}'));
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildUserDetailsCard(BuildContext context, AuthUser user) {
//     final theme = Theme.of(context).textTheme;
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage:
//                       (user.photoUrl != null && user.photoUrl!.isNotEmpty)
//                           ? NetworkImage(user.photoUrl!)
//                           : null,
//                   radius: 30,
//                   child: (user.photoUrl == null || user.photoUrl!.isEmpty)
//                       ? Icon(Icons.person_outline, size: 30)
//                       : null,
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                     child: Text(user.displayName ?? 'Usuario Sin Nombre',
//                         style: theme.headlineSmall)),
//               ],
//             ),
//             const Divider(height: 20),
//             _buildDetailRow('ID Usuario:', user.uid, theme),
//             _buildDetailRow('Email:', user.email, theme),
//             //       _buildDetailRow('Rol Actual:', user.role?.toUpperCase() ?? 'N/A', theme,
//             //          chipColor: (user.role == 'admin' ? Colors.purpleAccent : Colors.blueAccent).withOpacity(0.7)),
//             _buildDetailRow(
//                 'Registrado:',
//                 user.createdAt != null
//                     ? DateFormat('dd MMM yyyy, hh:mm a').format(user.createdAt!)
//                     : 'N/A',
//                 theme),
//             //    _buildDetailRow('Estado:', user.isActive ? 'Activo' : 'Inactivo', theme,
//             //       chipColor: user.isActive ? Colors.green : Colors.grey),
//             //  if (user.lastSignInAt != null)
//             //      _buildDetailRow('Último Acceso:', DateFormat('dd MMM yyyy, hh:mm a').format(user.lastSignInAt!), theme),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, dynamic value, TextTheme theme,
//       {Color? chipColor}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//               width: 120,
//               child: Text(label,
//                   style:
//                       theme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
//           Expanded(
//             child: chipColor != null
//                 ? Chip(
//                     label: Text(value.toString(),
//                         style: TextStyle(color: Colors.white)),
//                     backgroundColor: chipColor,
//                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2))
//                 : Text(value.toString(), style: theme.bodyMedium),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserManagementForm(BuildContext context, AuthUser currentUser) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text('Modificar Usuario',
//                   style: Theme.of(context).textTheme.titleLarge),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _displayNameController,
//                 decoration: const InputDecoration(
//                     labelText: 'Nombre Completo/Display Name',
//                     border: OutlineInputBorder()),
//                 validator: (value) => (value == null || value.isEmpty)
//                     ? 'Ingresa un nombre'
//                     : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                     labelText: 'Email (generalmente no editable)',
//                     border: OutlineInputBorder()),
//                 readOnly:
//                     true, // Email typically not directly editable by admin this way
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 decoration: const InputDecoration(
//                     labelText: 'Rol del Usuario', border: OutlineInputBorder()),
//                 items: _availableRoles.map((String role) {
//                   return DropdownMenuItem<String>(
//                     value: role,
//                     child: Text(role.toUpperCase()),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedRole = newValue;
//                   });
//                 },
//                 validator: (value) => value == null ? 'Rol es requerido' : null,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Text("Estado Activo: "),
//                   Switch(
//                     value: _isActive,
//                     onChanged: (value) {
//                       setState(() {
//                         _isActive = value;
//                       });
//                     },
//                   ),
//                   Text(_isActive ? "Sí" : "No"),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.save_alt_outlined),
//                     label: const Text('Guardar Cambios'),
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         // Update Profile Data
//                         final profileUpdate = UserProfileUpdateData(
//                           name: _displayNameController.text,
//                           // email: _emailController.text, // Only if email is meant to be updatable
//                         );
//                         //       context.read<UserManagementCubit>().updateUserProfile(currentUser.uid, profileUpdate);

//                         // Update Role if changed
//                         //        if (_selectedRole != null && _selectedRole != currentUser.role) {
//                         //           context.read<UserManagementCubit>().updateUserRole(currentUser.id, _selectedRole!);
//                         //        }

//                         // Update Status if changed
//                         //              if (_isActive != currentUser.isActive) {
//                         //              context.read<UserManagementCubit>().updateUserStatus(currentUser.id, _isActive);
//                         //          }
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
