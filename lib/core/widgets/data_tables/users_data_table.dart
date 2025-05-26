import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:core/core.dart'; // For User model, UserRole, UserStatus (if they exist as enums)
import 'package:intl/intl.dart'; // For date formatting

class UsersDataTable extends StatelessWidget {
  final List<AuthUser> users;
  final VoidCallback? onRefresh;
  final Function(String userId)? onEdit; // To open user management page
  final Function(String userId)? onDelete;
  final Function(String userId, bool newStatus)?
      onUpdateStatus; // For quick activate/deactivate
  final Function(String userId, String newRole)?
      onUpdateRole; // For quick role change if applicable

  const UsersDataTable({
    super.key,
    required this.users,
    this.onRefresh,
    this.onEdit,
    this.onDelete,
    this.onUpdateStatus,
    this.onUpdateRole,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No users found.'),
            if (onRefresh != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: onRefresh,
                ),
              ),
          ],
        ),
      );
    }

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1000, // Adjusted for user data
      sortAscending: true,
      columns: const [
        DataColumn2(label: Text('Usuario'), size: ColumnSize.L),
        DataColumn2(label: Text('Email'), size: ColumnSize.L),
        DataColumn2(label: Text('Rol'), size: ColumnSize.M),
        DataColumn2(label: Text('Registrado'), size: ColumnSize.M),
        DataColumn2(
            label: Text('Estado'),
            size: ColumnSize.S), // e.g., Active, Inactive, Banned
        DataColumn2(
            label: Text('Acciones'), size: ColumnSize.M, fixedWidth: 180),
      ],
      rows: users.map((user) {
        // Assuming User model has fields like:
        // String id;
        // String displayName; (or name)
        // String email;
        // String photoURL; (optional)
        // String role; (or UserRole enum)
        // DateTime createdAt;
        // bool isActive; (or UserStatus enum)

        String registrationDate = user.createdAt != null
            ? DateFormat('dd MMM yyyy').format(user.createdAt!)
            : 'N/A';

        return DataRow2(
          cells: [
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                            ? NetworkImage(user.photoUrl!)
                            : null,
                    radius: 16,
                    child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                        ? Icon(Icons.person_outline, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        user.displayName ??
                            user.email, // Show displayName or fallback to email
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            DataCell(Text(user.email, overflow: TextOverflow.ellipsis)),
            DataCell(Chip(
              label: Text(user.email?.toUpperCase() ?? 'N/A',
                  style: const TextStyle(fontSize: 10)),
              // backgroundColor: _getRoleColor(user.role).withOpacity(0.1), // Define _getRoleColor if needed
            )),
            DataCell(Text(registrationDate)),
            DataCell(
              Chip(
                label: Text(user.phoneNumber != null ? 'Activo' : 'Inactivo',
                    style: const TextStyle(fontSize: 10)),
                backgroundColor:
                    (user.phoneNumber != null ? Colors.green : Colors.grey)
                        .withOpacity(0.15),
                labelStyle: TextStyle(
                    color: user.phoneNumber != null
                        ? Colors.green.shade700
                        : Colors.grey.shade700),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Gestionar Usuario',
                      onPressed: () => onEdit!(user.uid),
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.redAccent),
                      tooltip: 'Eliminar Usuario',
                      onPressed: () => onDelete!(user.uid),
                    ),
                  if (onUpdateStatus != null)
                    IconButton(
                      icon: Icon(
                        user.phoneNumber != null
                            ? Icons.toggle_off_outlined
                            : Icons.toggle_on_outlined,
                        color: user.phoneNumber != null
                            ? Colors.grey
                            : Colors.green,
                        size: 22,
                      ),
                      tooltip:
                          user.phoneNumber != null ? 'Desactivar' : 'Activar',
                      onPressed: () =>
                          onUpdateStatus!(user.uid, user.phoneNumber != null),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
  // Optional: Color helper for roles if you have specific role colors
  // Color _getRoleColor(String? role) { ... }
}
