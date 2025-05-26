import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/features/dashboard/pages/dashboard_page.dart'; // Placeholder
import 'package:turbo_admin/features/places/pages/places_page.dart'; // Placeholder
import 'package:turbo_admin/features/places/pages/place_form_page.dart';
import 'package:turbo_admin/features/events/pages/events_page.dart'; // Placeholder
import 'package:turbo_admin/features/events/pages/event_form_page.dart';
import 'package:turbo_admin/features/reviews/pages/reviews_page.dart'; // Placeholder
import 'package:turbo_admin/features/reviews/pages/review_moderation_page.dart';
import 'package:turbo_admin/features/categories/pages/categories_page.dart'; // Placeholder
import 'package:turbo_admin/features/categories/pages/category_form_page.dart';
import 'package:turbo_admin/features/users/pages/users_page.dart'; // Placeholder
import 'package:turbo_admin/features/users/pages/user_management_page.dart';
// Import other pages as they are created (e.g., DashboardPage, SettingsPage)
// For AdminScaffold to know the current selection, we might need a wrapper or pass it down.

import 'package:turbo_admin/core/widgets/admin_scaffold.dart';

// Simple global key for the router's navigator state, useful for contextless navigation if needed
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(); // If using ShellRoute

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard', // Default route
    debugLogDiagnostics: true, // Log routing diagnostics for debugging
    routes: <RouteBase>[
      // === Dashboard ===
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) {
          // Replace with actual DashboardPage when created
          return const PlaceholderDashboardPage();
        },
      ),

      // === Places ===
      GoRoute(
        path: '/places',
        name: 'places',
        builder: (BuildContext context, GoRouterState state) {
          // Replace with actual PlacesPage (listing) when created
          return const PlaceholderPlacesListPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'new', //  /places/new
            name: 'newPlace',
            builder: (BuildContext context, GoRouterState state) {
              return const PlaceFormPage(); // No placeId means 'create'
            },
          ),
          GoRoute(
            path: ':placeId/edit', // /places/:placeId/edit
            name: 'editPlace',
            builder: (BuildContext context, GoRouterState state) {
              final placeId = state.pathParameters['placeId'];
              return PlaceFormPage(placeId: placeId);
            },
          ),
          // Potentially a details page: /places/:placeId
        ],
      ),

      // === Events ===
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (BuildContext context, GoRouterState state) {
          return const PlaceholderEventsListPage(); // Replace with actual EventsPage
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'new',
            name: 'newEvent',
            builder: (BuildContext context, GoRouterState state) {
              return const EventFormPage();
            },
          ),
          GoRoute(
            path: ':eventId/edit',
            name: 'editEvent',
            builder: (BuildContext context, GoRouterState state) {
              final eventId = state.pathParameters['eventId'];
              return EventFormPage(eventId: eventId);
            },
          ),
        ],
      ),

      // === Reviews ===
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (BuildContext context, GoRouterState state) {
          return const PlaceholderReviewsListPage(); // Replace with actual ReviewsPage
        },
        routes: <RouteBase>[
          GoRoute(
            path: ':reviewId/moderate',
            name: 'moderateReview',
            builder: (BuildContext context, GoRouterState state) {
              final reviewId = state.pathParameters['reviewId'];
              if (reviewId == null)
                return const Text("Error: Review ID missing"); // Or redirect
              return ReviewModerationPage(reviewId: reviewId);
            },
          ),
        ],
      ),

      // === Categories ===
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (BuildContext context, GoRouterState state) {
          return const PlaceholderCategoriesListPage(); // Replace with actual CategoriesPage
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'new',
            name: 'newCategory',
            builder: (BuildContext context, GoRouterState state) {
              return const CategoryFormPage();
            },
          ),
          GoRoute(
            path: ':categoryId/edit',
            name: 'editCategory',
            builder: (BuildContext context, GoRouterState state) {
              final categoryId = state.pathParameters['categoryId'];
              return CategoryFormPage(categoryId: categoryId);
            },
          ),
        ],
      ),

      // === Users ===
      GoRoute(
        path: '/users',
        name: 'users',
        builder: (BuildContext context, GoRouterState state) {
          return const PlaceholderUsersListPage(); // Replace with actual UsersPage
        },
        routes: <RouteBase>[
          GoRoute(
            path: ':userId/manage', // /users/:userId/manage
            name: 'manageUser',
            builder: (BuildContext context, GoRouterState state) {
              final userId = state.pathParameters['userId'];
              if (userId == null)
                return const Text("Error: User ID missing"); // Or redirect
              return UserManagementPage(userId: userId);
            },
          ),
          // No 'new' user route as user creation is typically via Firebase Auth or other services, not direct admin forms.
        ],
      ),

      // TODO: Add other routes (Settings, Profile, etc.)
      // TODO: Implement ShellRoute with AdminScaffold if a persistent navigation shell is desired.
      // This would wrap all main sections (Dashboard, Places, Events etc.) within AdminScaffold,
      // allowing the sidebar to remain visible and interact with the router for navigation.
    ],
    errorBuilder: (context, state) => Scaffold(
      // Basic error page
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.error?.message}')),
    ),
  );
}

// Placeholder Pages (to be replaced with actual implementations later)
// These are temporary until the actual list pages are created.
class PlaceholderDashboardPage extends StatelessWidget {
  const PlaceholderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminScaffold(
        title: "Dashboard",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Dashboard Page", style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text("Aquí irán las métricas y estadísticas principales"),
            ],
          ),
        ),
      );
}

class PlaceholderPlacesListPage extends StatelessWidget {
  const PlaceholderPlacesListPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminScaffold(
        title: "Gestión de Lugares",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Lista de Lugares", style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text("Aquí se mostrarán todos los lugares registrados"),
            ],
          ),
        ),
      );
}

class PlaceholderEventsListPage extends StatelessWidget {
  const PlaceholderEventsListPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminScaffold(
        title: "Gestión de Eventos",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Lista de Eventos", style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text("Aquí se mostrarán todos los eventos programados"),
            ],
          ),
        ),
      );
}

class PlaceholderReviewsListPage extends StatelessWidget {
  const PlaceholderReviewsListPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminScaffold(
        title: "Moderación de Reseñas",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.reviews, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Lista de Reseñas", style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text("Aquí se moderarán las reseñas de usuarios"),
            ],
          ),
        ),
      );
}

class PlaceholderCategoriesListPage extends StatelessWidget {
  const PlaceholderCategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminScaffold(
        title: "Gestión de Categorías",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Lista de Categorías", style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text("Aquí se gestionarán las categorías de lugares"),
            ],
          ),
        ),
      );
}

class PlaceholderUsersListPage extends StatelessWidget {
  const PlaceholderUsersListPage({super.key});

  @override
  Widget build(BuildContext context) => const AdminScaffold(
        title: "Gestión de Usuarios",
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Lista de Usuarios", style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text("Aquí se gestionarán los usuarios de la aplicación"),
            ],
          ),
        ),
      );
}
