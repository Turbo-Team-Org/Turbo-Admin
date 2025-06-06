import 'package:flutter/material.dart';

/// Widget base para las páginas del admin panel.
/// Este widget debe usarse en lugar de AdminScaffold en las páginas individuales
/// ya que el AdminScaffold ahora se maneja a través del ShellRoute.
class AdminPage extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const AdminPage({
    super.key,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: body,
    );
  }
}
