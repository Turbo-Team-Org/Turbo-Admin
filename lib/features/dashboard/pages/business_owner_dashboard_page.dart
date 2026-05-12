import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

/// Dashboard condicional para Business Owners según su estado de solicitud
class BusinessOwnerDashboardPage extends StatefulWidget {
  const BusinessOwnerDashboardPage({super.key});

  @override
  State<BusinessOwnerDashboardPage> createState() =>
      _BusinessOwnerDashboardPageState();
}

class _BusinessOwnerDashboardPageState extends State<BusinessOwnerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DashboardCubit>(),
      child: AdminPage(
        body: BlocBuilder<AdminAuthCubit, AdminAuthState>(
          builder: (context, authState) {
            if (authState is AdminAuthenticatedBusinessOwner) {
              return _buildBusinessOwnerDashboard(context, authState.request);
            } else if (authState is AdminAuthBusinessOwnerRegistered) {
              return _buildBusinessOwnerDashboard(context, authState.request);
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

  Widget _buildBusinessOwnerDashboard(
      BuildContext context, BusinessOwnerRequest request) {
    switch (request.status) {
      case BusinessOwnerRequestStatus.pending:
        return _buildPendingDashboard(context, request);
      case BusinessOwnerRequestStatus.approved:
        return _buildApprovedDashboard(context, request);
      case BusinessOwnerRequestStatus.rejected:
        return _buildRejectedDashboard(context, request);
      case BusinessOwnerRequestStatus.reviewing:
        return _buildPendingDashboard(context, request);
      default:
        return _buildPendingDashboard(context, request);
    }
  }

  Widget _buildPendingDashboard(
      BuildContext context, BusinessOwnerRequest request) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner naranja de estado pendiente
          _buildStatusBanner(
            context,
            title: 'Solicitud Pendiente de Aprobación',
            subtitle: 'Tu solicitud está siendo revisada por nuestro equipo',
            icon: Icons.hourglass_empty,
            color: Colors.orange,
            backgroundColor: Colors.orange.withOpacity(0.1),
          ),

          const SizedBox(height: 24),

          // Información del negocio
          _buildBusinessInfoCard(context, request),

          const SizedBox(height: 24),

          // Preview de funcionalidades bloqueadas
          _buildLockedFeaturesPreview(context),
        ],
      ),
    );
  }

  Widget _buildApprovedDashboard(
      BuildContext context, BusinessOwnerRequest request) {
    return _ApprovedOwnerDashboardView(
      request: request,
      host: this,
    );
  }

  Widget _buildRejectedDashboard(
      BuildContext context, BusinessOwnerRequest request) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner rojo de rechazo
          _buildStatusBanner(
            context,
            title: 'Solicitud Rechazada',
            subtitle: 'Tu solicitud no pudo ser aprobada en esta ocasión',
            icon: Icons.cancel,
            color: Colors.red,
            backgroundColor: Colors.red.withOpacity(0.1),
          ),

          const SizedBox(height: 24),

          // Información del negocio
          _buildBusinessInfoCard(context, request),

          const SizedBox(height: 24),

          // Motivo del rechazo si existe
          if (request.rejectionReason != null) ...[
            _buildRejectionReasonCard(context, request.rejectionReason!),
            const SizedBox(height: 24),
          ],

          // Opción para solicitar nuevamente
          _buildReapplyCard(context),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    bool showCelebration = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          if (showCelebration) ...[
            const SizedBox(width: 16),
            Icon(
              Icons.celebration,
              size: 32,
              color: color,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBusinessInfoCard(
      BuildContext context, BusinessOwnerRequest request) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Negocio',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nombre del Negocio', request.businessName),
            _buildInfoRow('Propietario', request.displayName),
            _buildInfoRow('Email', request.email),
            _buildInfoRow('Descripción', request.businessDescription),
            if (request.businessAddress.isNotEmpty)
              _buildInfoRow('Dirección', request.businessAddress),
            if (request.phoneNumber != null && request.phoneNumber!.isNotEmpty)
              _buildInfoRow('Teléfono', request.phoneNumber!),
            if (request.website != null && request.website!.isNotEmpty)
              _buildInfoRow('Sitio Web', request.website!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedFeaturesPreview(BuildContext context) {
    final features = [
      {
        'title': 'Gestión de Lugares',
        'icon': Icons.place,
        'description': 'Administra tus ubicaciones'
      },
      {
        'title': 'Eventos',
        'icon': Icons.event,
        'description': 'Crea y gestiona eventos'
      },
      {
        'title': 'Reseñas',
        'icon': Icons.rate_review,
        'description': 'Modera comentarios'
      },
      {
        'title': 'Estadísticas',
        'icon': Icons.analytics,
        'description': 'Analiza el rendimiento'
      },
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Funcionalidades Disponibles (Próximamente)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            feature['icon'] as IconData,
                            size: 32,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            feature['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            feature['description'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Bloqueado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectionReasonCard(BuildContext context, String reason) {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Motivo del Rechazo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reason,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReapplyCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Quieres solicitar nuevamente?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Puedes enviar una nueva solicitud con información actualizada.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/register-business');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Solicitar Nuevamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildErrorState(BuildContext context, String message) {
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
            'Error',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AdminAuthCubit>().checkAuthStatus(),
            child: const Text('Reintentar'),
          ),
        ],
      ),
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

  Widget _buildOwnerAnalyticsSection(
    BuildContext context,
    DashboardStats stats,
  ) {
    final err = stats.ownerAnalyticsError;
    final dash = stats.ownerPlaceDashboard;

    if (err != null && dash == null) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_outlined, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(child: Text(err)),
            ],
          ),
        ),
      );
    }

    if (dash == null) {
      return const SizedBox.shrink();
    }

    final rangeLabel = dash.dateRange.displayText;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rendimiento del negocio',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${dash.placeName} · $rangeLabel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildMiniMetric(
                  context,
                  'Vistas',
                  dash.summary.totalViews.toString(),
                ),
                _buildMiniMetric(
                  context,
                  'Visitantes únicos',
                  dash.summary.uniqueVisitors.toString(),
                ),
                _buildMiniMetric(
                  context,
                  'Reservas (periodo)',
                  stats.ownerReservationsLast30Days.toString(),
                ),
                _buildMiniMetric(
                  context,
                  'Rating (lugar)',
                  dash.summary.averageRating.toStringAsFixed(1),
                ),
              ],
            ),
            if (dash.kpiMetrics.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'KPIs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              ...dash.kpiMetrics.map(
                (m) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(m.title),
                  trailing: Text(
                    m.value.toStringAsFixed(m.unit == 'percentage' ? 1 : 0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMetric(BuildContext context, String label, String value) {
    return Chip(
      label: Text('$label: $value'),
    );
  }
}

class _ApprovedOwnerDashboardView extends StatefulWidget {
  const _ApprovedOwnerDashboardView({
    required this.request,
    required this.host,
  });

  final BusinessOwnerRequest request;
  final _BusinessOwnerDashboardPageState host;

  @override
  State<_ApprovedOwnerDashboardView> createState() =>
      _ApprovedOwnerDashboardViewState();
}

class _ApprovedOwnerDashboardViewState extends State<_ApprovedOwnerDashboardView> {
  var _didRequestLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didRequestLoad) {
      _didRequestLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<DashboardCubit>().loadBusinessOwnerDashboard(
              widget.request.userId,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, dashboardState) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.host._buildStatusBanner(
                context,
                title: '¡Bienvenido a Turbo Admin!',
                subtitle:
                    'Tu solicitud ha sido aprobada. Ya puedes gestionar tu negocio',
                icon: Icons.verified_user,
                color: Colors.green,
                backgroundColor: Colors.green.withOpacity(0.1),
                showCelebration: true,
              ),
              const SizedBox(height: 24),
              widget.host._buildBusinessInfoCard(
                context,
                widget.request,
              ),
              const SizedBox(height: 24),
              if (dashboardState is DashboardLoaded) ...[
                widget.host._buildStatsGrid(dashboardState.stats),
                const SizedBox(height: 16),
                widget.host._buildOwnerAnalyticsSection(
                  context,
                  dashboardState.stats,
                ),
                const SizedBox(height: 24),
                widget.host._buildQuickActions(context),
              ] else if (dashboardState is DashboardLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (dashboardState is DashboardError) ...[
                widget.host._buildErrorState(
                  context,
                  dashboardState.message,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
