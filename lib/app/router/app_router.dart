import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

// Dashboard
import 'package:turbo_admin/features/dashboard/pages/dashboard_page.dart';

// Places
import 'package:turbo_admin/features/places/pages/places_page.dart';
import 'package:turbo_admin/features/places/pages/place_form_page.dart';

// Events
import 'package:turbo_admin/features/events/pages/events_page.dart';
import 'package:turbo_admin/features/events/pages/event_form_page.dart';

// Reviews
import 'package:turbo_admin/features/reviews/pages/reviews_page.dart';
import 'package:turbo_admin/features/reviews/pages/review_moderation_page.dart';

// Categories
import 'package:turbo_admin/features/categories/pages/categories_page.dart';
import 'package:turbo_admin/features/categories/pages/category_form_page.dart';

// Users
import 'package:turbo_admin/features/users/pages/users_page.dart';
import 'package:turbo_admin/features/users/pages/user_management_page.dart';

// Diagnostics
import 'package:turbo_admin/features/diagnostics/pages/diagnostics_page.dart';

// Auth
import 'package:turbo_admin/features/auth/pages/login_page.dart';
import 'package:turbo_admin/features/auth/pages/register_page.dart';
import 'package:turbo_admin/features/auth/pages/loading_page.dart';

// Simple global key for the router's navigator state, useful for contextless navigation if needed
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(); // If using ShellRoute

/// Verificar estado de autenticación para redirecciones
String? _handleRedirect(BuildContext context, GoRouterState state) {
  try {
    final adminAuthCubit = GetIt.instance<AdminAuthCubit>();
    final authState = adminAuthCubit.state;

    final currentLocation = state.matchedLocation;
    final isLoggingIn = currentLocation == '/login';
    final isRegistering = currentLocation == '/register';
    final isOnAuthPage = isLoggingIn || isRegistering;

    // Debug logging
    print('🔄 Router redirect check:');
    print('   Current location: $currentLocation');
    print('   Auth state: ${authState.runtimeType}');

    // Estrategia simplificada:
    // 1. Si está autenticado y en página de auth → dashboard
    if (authState is AdminAuthAuthenticated && isOnAuthPage) {
      print('   ✅ Authenticated user on auth page - redirecting to dashboard');
      return '/dashboard';
    }

    // 2. Si NO está autenticado y NO está en página de auth → login
    if ((authState is AdminAuthUnauthenticated ||
            authState is AdminAuthError) &&
        !isOnAuthPage) {
      print(
          '   ❌ Unauthenticated user not on auth page - redirecting to login');
      return '/login';
    }

    // 3. Si es estado inicial, iniciar verificación pero permitir navegación
    if (authState is AdminAuthInitial) {
      print('   ⚡ Initial state - triggering checkAuthStatus, no redirect');
      Future.microtask(() => adminAuthCubit.checkAuthStatus());
    }

    print('   ➡️  No redirect needed');
    return null;
  } catch (e) {
    print('   💥 Error in redirect: $e');
    return '/login';
  }
}

/// Transición personalizada para navegación principal (entre secciones del sidebar)
Page<T> _buildPageWithSlideTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// Transición para formularios y modales
Page<T> _buildPageWithScaleTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeOutBack;

      var scaleTween = Tween(begin: 0.8, end: 1.0).chain(
        CurveTween(curve: curve),
      );

      var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: curve),
      );

      return ScaleTransition(
        scale: animation.drive(scaleTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

/// Transición para páginas de autenticación
Page<T> _buildPageWithFadeTransition<T extends Object?>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

/// Router principal de la aplicación
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    redirect: _handleRedirect, // Manejar autenticación a nivel de router
    routes: <RouteBase>[
/*      // === Auth ===
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const LoginPage(),
        ),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const RegisterPage(),
        ),
      ),
*/
      // === Dashboard ===
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const DashboardPage(),
        ),
      ),

      // === Diagnóstico ===
      GoRoute(
        path: '/diagnostics',
        name: 'diagnostics',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const DiagnosticsPage(),
        ),
      ),

      // === Places ===
      GoRoute(
        path: '/places',
        name: 'places',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const PlaceholderPlacesListPage(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'new', //  /places/new
            name: 'newPlace',
            pageBuilder: (context, state) => _buildPageWithScaleTransition(
              context,
              state,
              const PlaceFormPage(),
            ),
          ),
          GoRoute(
            path: ':placeId/edit', // /places/:placeId/edit
            name: 'editPlace',
            pageBuilder: (context, state) {
              final placeId = state.pathParameters['placeId'];
              return _buildPageWithScaleTransition(
                context,
                state,
                PlaceFormPage(placeId: placeId),
              );
            },
          ),
        ],
      ),

      // === Events ===
      GoRoute(
        path: '/events',
        name: 'events',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const PlaceholderEventsListPage(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'new',
            name: 'newEvent',
            pageBuilder: (context, state) => _buildPageWithScaleTransition(
              context,
              state,
              const EventFormPage(),
            ),
          ),
          GoRoute(
            path: ':eventId/edit',
            name: 'editEvent',
            pageBuilder: (context, state) {
              final eventId = state.pathParameters['eventId'];
              return _buildPageWithScaleTransition(
                context,
                state,
                EventFormPage(eventId: eventId),
              );
            },
          ),
        ],
      ),

      // === Reviews ===
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const PlaceholderReviewsListPage(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: ':reviewId/moderate',
            name: 'moderateReview',
            pageBuilder: (context, state) {
              final reviewId = state.pathParameters['reviewId'];
              if (reviewId == null) {
                return _buildPageWithFadeTransition(
                  context,
                  state,
                  const Scaffold(
                    body: Center(
                      child: Text("Error: Review ID missing"),
                    ),
                  ),
                );
              }
              return _buildPageWithScaleTransition(
                context,
                state,
                ReviewModerationPage(reviewId: reviewId),
              );
            },
          ),
        ],
      ),

      // === Categories ===
      GoRoute(
        path: '/categories',
        name: 'categories',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const PlaceholderCategoriesListPage(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'new',
            name: 'newCategory',
            pageBuilder: (context, state) => _buildPageWithScaleTransition(
              context,
              state,
              const CategoryFormPage(),
            ),
          ),
          GoRoute(
            path: ':categoryId/edit',
            name: 'editCategory',
            pageBuilder: (context, state) {
              final categoryId = state.pathParameters['categoryId'];
              return _buildPageWithScaleTransition(
                context,
                state,
                CategoryFormPage(categoryId: categoryId),
              );
            },
          ),
        ],
      ),

      // === Users ===
      GoRoute(
        path: '/users',
        name: 'users',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context,
          state,
          const PlaceholderUsersListPage(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: ':userId/manage',
            name: 'manageUser',
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId'];
              if (userId == null) {
                return _buildPageWithFadeTransition(
                  context,
                  state,
                  const Scaffold(
                    body: Center(
                      child: Text("Error: User ID missing"),
                    ),
                  ),
                );
              }
              return _buildPageWithScaleTransition(
                context,
                state,
                UserManagementPage(userId: userId),
              );
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

// Las páginas reales están implementadas en sus respectivos features con BLoC pattern
