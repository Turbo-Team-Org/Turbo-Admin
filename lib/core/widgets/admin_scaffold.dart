import 'package:flutter/material.dart';
// Import AdminSidebar and AdminAppBar once they are created
import 'admin_sidebar.dart';
import 'admin_app_bar.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we should show the mobile layout based on screen width
    // This is a simple way, responsive_framework might offer more sophisticated methods
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      // Drawer for mobile view, sidebar for larger screens
      drawer: isMobile ? const AdminSidebar() : null,
      appBar: isMobile
          ? AppBar(
              // Simple AppBar for mobile
              title: Text(title),
              actions: actions,
            )
          : null, // No separate AppBar for desktop if AdminAppBar is part of the body column
      body: Row(
        children: [
          // Sidebar responsivo: shown only on non-mobile
          if (!isMobile) const AdminSidebar(),

          // Content area
          Expanded(
            child: Column(
              children: [
                // AppBar con breadcrumbs (conditionally shown if not mobile, or integrated differently)
                // If AdminAppBar is designed to be always visible, it might not be conditional.
                // For this example, let's assume AdminAppBar is for larger screens or part of the main content.
                if (!isMobile) AdminAppBar(title: title, actions: actions),

                // Body content
                Expanded(
                  child: Padding(
                    // Add some default padding around the body content
                    padding: const EdgeInsets.all(16.0),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
