import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/categories/pages/categories_page.dart';
import 'package:turbo_admin/features/categories/pages/category_form_page.dart';
import 'package:turbo_admin/features/users/pages/users_page.dart';
import 'package:turbo_admin/features/users/pages/user_management_page.dart';
import 'package:turbo_admin/features/diagnostics/pages/diagnostics_page.dart';
import 'package:turbo_admin/features/business_requests/pages/business_requests_page.dart';
import 'package:turbo_admin/features/auth/pages/login_page.dart';
import 'package:turbo_admin/features/auth/pages/register_page.dart';
import 'package:turbo_admin/features/auth/pages/loading_page.dart';
import 'package:turbo_admin/features/auth/pages/business_owner_registration_page.dart';
import 'package:turbo_admin/features/dashboard/pages/business_owner_dashboard_page.dart';
import 'package:turbo_admin/features/reservations/pages/reservation_dashboard_page.dart';

// Dashboard
import 'package:turbo_admin/features/dashboard/pages/dashboard_page.dart';

// Places
import 'package:turbo_admin/features/places/pages/places_page.dart';
import 'package:turbo_admin/features/places/pages/place_form_page.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';

// Events
import 'package:turbo_admin/features/events/pages/events_page.dart';
import 'package:turbo_admin/features/events/pages/event_form_page.dart';

// Reviews
import 'package:turbo_admin/features/reviews/pages/reviews_page.dart';
import 'package:turbo_admin/features/reviews/pages/review_moderation_page.dart';

// Simple global key for the router's navigator state, useful for contextless navigation if needed
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

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
    if (kDebugMode) {
      debugPrint('🔄 Router redirect check:');
      debugPrint('   Current location: $currentLocation');
      debugPrint('   Auth state: ${authState.runtimeType}');
    }

    // Estrategia mejorada:
    // 1. Si está autenticado y en página de auth → dashboard apropiado
    if ((authState is AdminAuthenticatedAdmin ||
            authState is AdminAuthenticatedBusinessOwner) &&
        isOnAuthPage) {
      if (kDebugMode) {
        debugPrint(
            '   ✅ Authenticated user on auth page - redirecting to dashboard');
      }
      // Redirigir según el tipo de usuario
      if (authState is AdminAuthenticatedAdmin) {
        return '/dashboard';
      } else if (authState is AdminAuthenticatedBusinessOwner) {
        return '/business-owner-dashboard';
      }
      return '/dashboard'; // fallback
    }

    // 2. Si es estado inicial o de carga, permitir navegación y verificar en background
    if (authState is AdminAuthInitial || authState is AdminAuthLoading) {
      if (kDebugMode) {
        debugPrint(
            '   ⚡ Initial/Loading state - allowing navigation, checking auth in background');
      }
      // Verificar autenticación en background sin bloquear navegación
      if (authState is AdminAuthInitial) {
        Future.microtask(() => adminAuthCubit.checkAuthStatus());
      }
      return null;
    }

    // 3. Si NO está autenticado y NO está en página de auth → login
    if ((authState is AdminAuthUnauthenticated ||
            authState is AdminAuthError) &&
        !isOnAuthPage) {
      if (kDebugMode) {
        debugPrint(
            '   ❌ Unauthenticated user not on auth page - redirecting to login');
      }
      return '/login';
    }

    if (kDebugMode) {
      debugPrint('   ➡️  No redirect needed');
    }
    return null;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('   💥 Error in redirect: $e');
    }
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
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    routes: <RouteBase>[
      // === Auth Routes ===
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

      GoRoute(
        path: '/register-business',
        name: 'registerBusiness',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const BusinessOwnerRegistrationPage(),
        ),
      ),

      // === Main Shell Route ===
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AdminScaffold(
            title: _getTitleFromRoute(state),
            body: child,
          );
        },
        routes: [
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

          // === Business Owner Dashboard ===
          GoRoute(
            path: '/business-owner-dashboard',
            name: 'businessOwnerDashboard',
            pageBuilder: (context, state) => _buildPageWithSlideTransition(
              context,
              state,
              const BusinessOwnerDashboardPage(),
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

          // === Business Requests (Solo Super Admins) ===
          GoRoute(
            path: '/business-requests',
            name: 'businessRequests',
            pageBuilder: (context, state) => _buildPageWithSlideTransition(
              context,
              state,
              const BusinessRequestsPage(),
            ),
          ),

          // === Places ===
          GoRoute(
            path: '/places',
            name: 'places',
            pageBuilder: (context, state) => _buildPageWithSlideTransition(
              context,
              state,
              BlocProvider<PlacesCubit>.value(
                value: GetIt.instance<PlacesCubit>()..loadPlaces(),
                child: const PlacesListPage(),
              ),
            ),
            routes: <RouteBase>[
              GoRoute(
                path: 'new',
                name: 'newPlace',
                pageBuilder: (context, state) {
                  return _buildPageWithScaleTransition(
                    context,
                    state,
                    BlocProvider<PlaceFormCubit>.value(
                      value: GetIt.instance<PlaceFormCubit>()..clearState(),
                      child: const PlaceFormPage(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: ':placeId/edit',
                name: 'editPlace',
                pageBuilder: (context, state) {
                  final placeId = state.pathParameters['placeId'];
                  return _buildPageWithScaleTransition(
                    context,
                    state,
                    BlocProvider<PlaceFormCubit>.value(
                      value: GetIt.instance<PlaceFormCubit>()..clearState(),
                      child: PlaceFormPage(placeId: placeId),
                    ),
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

          // === Reservations ===
          GoRoute(
            path: '/reservations',
            name: 'reservations',
            pageBuilder: (context, state) => _buildPageWithSlideTransition(
              context,
              state,
              const ReservationDashboardPage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.error?.message}')),
    ),
  );

  /// Helper method to get the title based on the current route
  static String _getTitleFromRoute(GoRouterState state) {
    final name = state.name;
    switch (name) {
      case 'dashboard':
        return 'Dashboard';
      case 'businessOwnerDashboard':
        return 'Dashboard Business Owner';
      case 'places':
      case 'newPlace':
      case 'editPlace':
        return 'Lugares';
      case 'events':
      case 'newEvent':
      case 'editEvent':
        return 'Eventos';
      case 'reviews':
      case 'moderateReview':
        return 'Reseñas';
      case 'categories':
      case 'newCategory':
      case 'editCategory':
        return 'Categorías';
      case 'users':
      case 'manageUser':
        return 'Usuarios';
      case 'diagnostics':
        return 'Diagnóstico';
      case 'businessRequests':
        return 'Solicitudes de Business Owners';
      case 'reservations':
        return 'Reservaciones';
      default:
        return 'Turbo Admin';
    }
  }
}

// Las páginas reales están implementadas en sus respectivos features con BLoC pattern
