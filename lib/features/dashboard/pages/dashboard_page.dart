import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

/// Página principal del Dashboard con métricas y estadísticas
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<DashboardCubit>()..loadDashboardStats(),
      child: AdminPage(
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section con información del usuario
                    _buildWelcomeSection(context),

                    const SizedBox(height: 24),

                    // Stats Grid simplificado
                    _buildStatsGrid(state.stats),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActions(context),
                  ],
                ),
              );
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error cargando dashboard',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<DashboardCubit>().loadDashboardStats(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Estado inicial'));
            }
          },
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

  Widget _buildQuickActions(BuildContext context) {
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

  Widget _buildWelcomeSection(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      bloc: GetIt.instance<AdminAuthCubit>(),
      builder: (context, authState) {
        if (authState is AdminAuthAuthenticated) {
          final user = authState.user;
          return Card(
            elevation: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53E3E), Color(0xFFFF6B35)],
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
                        child: const Icon(
                          Icons.business,
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
                        const Icon(
                          Icons.business_center,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Panel de Administración de Negocios',
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

        // Fallback si no hay usuario autenticado
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Icon(Icons.dashboard, size: 32, color: Colors.grey),
                const SizedBox(width: 16),
                Text(
                  'Panel de Administración',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
