import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// Assuming 'core' is the name of your turbo_core package
// and it has an init.dart or similar for initialization.
// Adjust the import if your turbo_core package structure is different.
import 'package:core/core.dart';
import 'package:turbo_admin/app/app.dart';
import 'package:turbo_admin/di/injection.dart'; // For initUIDependencies

// It's good practice to have a global GetIt instance
final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize turbo_core (ya configurado)
  // Assuming initCoreDependencies is a function exposed by your turbo_core package
  // This might need adjustment based on how turbo_core is actually structured.
  // If initCoreDependencies is not part of 'package:core/core.dart',
  // this will require knowing the correct import from turbo_core.

  // Initialize solo BLoCs de UI
  await initUIDependencies(); // This will be created in a later step

  runApp(const TurboAdminApp());
}
