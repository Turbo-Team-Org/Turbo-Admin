import 'package:flutter/material.dart';

class TurboAdminApp extends StatelessWidget {
  const TurboAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turbo Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Placeholder theme
        useMaterial3: true,
      ),
      home: const PlaceholderWidget(), // Placeholder for initial screen
    );
  }
}

// Simple placeholder widget for now
class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Turbo Admin Initializing...'),
      ),
    );
  }
}
