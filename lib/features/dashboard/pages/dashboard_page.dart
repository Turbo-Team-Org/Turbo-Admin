import 'package:flutter/material.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
// Import DashboardCubit if you plan to use it here

class PlaceholderDashboardPage extends StatelessWidget { // Renamed for clarity if it was different
  const PlaceholderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Dashboard',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dashboard Content', style: Theme.of(context).textTheme.headlineMedium),
            // Add StatsCards or charts here later
          ],
        ),
      ),
    );
  }
}
