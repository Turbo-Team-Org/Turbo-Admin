import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For potential breadcrumb logic

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // This might be derived from the route or passed explicitly
  final List<Widget>? actions;

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Example of how you might get current route path for breadcrumbs (simplified)
    // final String currentPath = GoRouterState.of(context).uri.toString();
    // You would need a utility to parse this path into breadcrumb segments.

    return AppBar(
      automaticallyImplyLeading: false, // Usually false if sidebar is present
      title: Text(title), // Title is passed from AdminScaffold
      // leading: Text("Breadcrumbs: $currentPath"), // Placeholder for breadcrumbs
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
