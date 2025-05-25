import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Using a standard AppBar for consistency
    return AppBar(
      // If this AppBar is used in a context where a leading back button is automatically added, 
      // and you don't want it (e.g. main sections), set automaticallyImplyLeading to false.
      automaticallyImplyLeading: false, 
      title: Text(title),
      actions: actions,
      // Example of adding some style
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard AppBar height
}
