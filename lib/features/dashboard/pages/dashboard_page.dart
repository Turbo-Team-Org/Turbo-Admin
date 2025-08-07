import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/core/widgets/firebase_loading_widget.dart';
import 'package:turbo_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

/// Página principal del Dashboard para Super Admins y Admins aprobados
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<DashboardCubit>()..loadDashboardStats(),
      child: AdminPage(
        body: BlocBuilder<AdminAuthCubit, AdminAuthState>(
          builder: (context, authState) {
            // Solo mostrar dashboard completo para admins autenticados
            if (authState is AdminAuthenticatedAdmin) {
              return _buildAdminDashboard(context, authState.user);
            } else if (authState is AdminAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (authState is AdminAuthError) {
              return _buildErrorState(context, authState.message);
            } else {
              return _buildUnauthenticatedState(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdminDashboard(BuildContext context, AdminUser user) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section con información del admin
                _buildWelcomeSection(context, user),

                const SizedBox(height: 24),

                // Stats Grid completo
                _buildStatsGrid(state.stats),

                const SizedBox(height: 24),

                // Quick Actions para admins
                _buildAdminQuickActions(context, user),
              ],
            ),
          );
        } else if (state is DashboardError) {
          return _buildErrorState(context, state.message);
        } else {
          return const Center(child: Text('Estado inicial'));
        }
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context, AdminUser user) {
    final isSuperAdmin = user.role.name == 'superAdmin';

    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: isSuperAdmin
                ? [const Color(0xFF7C3AED), const Color(0xFFA855F7)]
                : [const Color(0xFFE53E3E), const Color(0xFFFF6B35)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    isSuperAdmin ? Icons.admin_panel_settings : Icons.business,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido, ${user.displayName ?? 'Administrador'}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MuseoSans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'MuseoSans',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    isSuperAdmin ? Icons.security : Icons.business_center,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSuperAdmin
                        ? 'Super Administrador - Acceso Completo'
                        : 'Administrador - Panel de Control',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'MuseoSans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
            'Lugares', stats.totalPlaces.toString(), Icons.place, Colors.blue),
        _buildStatCard(
            'Eventos', stats.totalEvents.toString(), Icons.event, Colors.green),
        _buildStatCard('Reseñas', stats.totalReviews.toString(),
            Icons.rate_review, Colors.orange),
        _buildStatCard('Categorías', stats.totalCategories.toString(),
            Icons.category, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminQuickActions(BuildContext context, AdminUser user) {
    final isSuperAdmin = user.role.name == 'superAdmin';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (isSuperAdmin) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      context.goNamed('businessRequests');
                    },
                    icon: const Icon(Icons.pending_actions),
                    label: const Text('Solicitudes Pendientes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navegar a gestión de usuarios
                    },
                    icon: const Icon(Icons.people),
                    label: const Text('Gestionar Usuarios'),
                  ),
                ],
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_location),
                  label: const Text('Nuevo Lugar'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.event),
                  label: const Text('Nuevo Evento'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.category),
                  label: const Text('Nueva Categoría'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return FirebaseErrorWidget(
      errorMessage: message,
      onRetry: () {
        // Intentar recargar el dashboard
        context.read<DashboardCubit>().loadDashboardStats();
      },
    );
  }

  Widget _buildUnauthenticatedState(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.login,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No Autenticado',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Por favor inicia sesión para acceder al panel.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
