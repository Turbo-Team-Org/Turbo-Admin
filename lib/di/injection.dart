import 'package:get_it/get_it.dart';
import 'package:turbo_admin/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';
// Import other Cubits as they are created in Phase 2

// Use the global GetIt instance from main.dart, or re-declare if preferred for this scope
// For consistency with potential GetIt usage in core, it's often good to use a shared instance.
// However, the prompt for main.dart declared `final getIt = GetIt.instance;`
// So we will assume GetIt.instance is the way to go.

Future<void> initUIDependencies() async {
  // Using GetIt.instance directly as per main.dart setup
  final di = GetIt.instance;

  // Register Cubits for UI state management
  // These are typically registered as factories because they might be created
  // multiple times or have state that shouldn't persist globally like a singleton.
  
  di.registerFactory(() => DashboardCubit(
      // Repositories are expected to be already registered in GetIt by initCoreDependencies()
      // GetIt will resolve them automatically when DashboardCubit is created.
      ));
      
  di.registerFactory(() => PlacesCubit(
      // Same here, PlaceRepository and PlaceService are expected from core's DI setup
      ));
      
  di.registerFactory(() => PlaceFormCubit(
      // CategoryRepository, PlaceRepository, PlaceService expected from core's DI.
      ));

  // Example for future Cubits (Phase 2):
  // di.registerFactory(() => EventsCubit());
  // di.registerFactory(() => EventFormCubit());
  // ... and so on for Reviews, Categories, Users
}
