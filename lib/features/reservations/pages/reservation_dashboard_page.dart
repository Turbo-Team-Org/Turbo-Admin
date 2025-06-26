import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import '../cubit/reservation_dashboard_cubit.dart' as dashboard;
import '../cubit/reservation_management_cubit.dart';
import '../widgets/today_reservations_section.dart';
import '../widgets/upcoming_reservations_section.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

/// Página principal del dashboard de reservas para business owners
/// Muestra estadísticas, reservas del día y próximas reservas
class ReservationDashboardPage extends StatelessWidget {
  const ReservationDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, authState) {
        // Verificar que hay usuario autenticado
        if (authState is! AdminAuthenticatedAdmin &&
            authState is! AdminAuthenticatedBusinessOwner) {
          return const _UnauthenticatedView();
        }

        return const _AuthenticatedReservationDashboard();
      },
    );
  }
}

class _AuthenticatedReservationDashboard extends StatefulWidget {
  const _AuthenticatedReservationDashboard();

  @override
  State<_AuthenticatedReservationDashboard> createState() =>
      _AuthenticatedReservationDashboardState();
}

class _AuthenticatedReservationDashboardState
    extends State<_AuthenticatedReservationDashboard> {
  late final dashboard.ReservationDashboardCubit _dashboardCubit;
  late final ReservationManagementCubit _managementCubit;

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  void _initializeCubits() {
    try {
      // Obtener el place ID del usuario autenticado
      final adminAuthCubit = context.read<AdminAuthCubit>();
      final manageablePlaceIds = adminAuthCubit.manageablePlaceIds;

      // Para desarrollo, usar un placeId temporal si no hay lugares específicos
      String placeId;
      if (manageablePlaceIds.isEmpty) {
        // Si es super admin o no hay lugares específicos, usar un ID temporal
        placeId = 'default-place-id';
      } else {
        placeId = manageablePlaceIds.first;
      }

      // Crear los cubits con el placeId
      _dashboardCubit = GetIt.instance.get<dashboard.ReservationDashboardCubit>(
        param1: placeId,
      );

      _managementCubit = GetIt.instance.get<ReservationManagementCubit>(
        param1: placeId,
      );

      // Cargar datos después de que el widget esté montado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _dashboardCubit.loadDashboard();
        }
      });
    } catch (e) {
      debugPrint('❌ Error inicializando cubits de reservas: $e');
      // Crear cubits fallback que muestren error
      _dashboardCubit = GetIt.instance.get<dashboard.ReservationDashboardCubit>(
        param1: 'fallback-place-id',
      );
      _managementCubit = GetIt.instance.get<ReservationManagementCubit>(
        param1: 'fallback-place-id',
      );
    }
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    _managementCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _dashboardCubit),
        BlocProvider.value(value: _managementCubit),
      ],
      child: const _ReservationDashboardView(),
    );
  }
}

class _UnauthenticatedView extends StatelessWidget {
  const _UnauthenticatedView();

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 16),
            const Text(
              'Acceso Requerido',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'MuseoSans',
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Necesitas estar autenticado para acceder al dashboard de reservas',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'MuseoSans',
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AdminAuthCubit>().checkAuthStatus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Verificar Autenticación',
                style: TextStyle(
                  fontFamily: 'MuseoSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationDashboardView extends StatelessWidget {
  const _ReservationDashboardView();

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      body: BlocBuilder<dashboard.ReservationDashboardCubit,
          dashboard.ReservationDashboardState>(
        builder: (context, state) {
          if (state is dashboard.ReservationDashboardLoading) {
            return const _LoadingView();
          } else if (state is dashboard.ReservationDashboardError) {
            return _ErrorView(message: state.message);
          } else if (state is dashboard.ReservationDashboardLoaded) {
            return _LoadedView(
              stats: state.stats,
              todayReservations: state.todayReservations,
              weekReservations: state.weekReservations,
            );
          }

          return const _EmptyView();
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53E3E)),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando dashboard de reservas...',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'MuseoSans',
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          const Text(
            'Error al cargar el dashboard',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'MuseoSans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'MuseoSans',
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context
                  .read<dashboard.ReservationDashboardCubit>()
                  .loadDashboard();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reintentar',
              style: TextStyle(
                fontFamily: 'MuseoSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          const Text(
            'Dashboard de Reservas',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'MuseoSans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Carga las reservas de tu lugar',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'MuseoSans',
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context
                  .read<dashboard.ReservationDashboardCubit>()
                  .loadDashboard();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cargar Dashboard',
              style: TextStyle(
                fontFamily: 'MuseoSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final dashboard.ReservationStats stats;
  final List<Reservation> todayReservations;
  final List<Reservation> weekReservations;

  const _LoadedView({
    required this.stats,
    required this.todayReservations,
    required this.weekReservations,
  });

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título
          _buildHeader(context),

          const SizedBox(height: 24),

          // KPIs principales
          _buildKPISection(),

          const SizedBox(height: 32),

          // Contenido principal en dos columnas
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda - Reservas de hoy
                Expanded(
                  flex: 2,
                  child: TodayReservationsSection(
                    reservations: todayReservations,
                    onReservationTap: (reservation) {
                      _showReservationDetails(context, reservation);
                    },
                  ),
                ),

                const SizedBox(width: 24),

                // Columna derecha - Próximas reservas (esta semana)
                Expanded(
                  flex: 1,
                  child: UpcomingReservationsSection(
                    reservations: weekReservations,
                    onReservationTap: (reservation) {
                      _showReservationDetails(context, reservation);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDetails(BuildContext context, Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reserva - ${reservation.customerName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${reservation.customerName}'),
            if (reservation.customerEmail != null)
              Text('Email: ${reservation.customerEmail}'),
            if (reservation.customerPhone != null)
              Text('Teléfono: ${reservation.customerPhone}'),
            Text('Personas: ${reservation.partySize}'),
            Text('Fecha: ${_formatDateTime(reservation.startTime)}'),
            Text('Estado: ${_getStatusText(reservation.status)}'),
            if (reservation.specialRequests?.isNotEmpty ?? false)
              Text('Solicitudes especiales: ${reservation.specialRequests}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pendiente';
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.rejected:
        return 'Rechazada';
      case ReservationStatus.cancelled:
        return 'Cancelada';
      case ReservationStatus.checkedIn:
        return 'Check-in realizado';
      case ReservationStatus.completed:
        return 'Completada';
      case ReservationStatus.noShow:
        return 'No-show';
      default:
        return 'Pendiente';
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard de Reservas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'MuseoSans',
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gestiona las reservas de tu lugar',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'MuseoSans',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        // Botón de actualizar
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE53E3E),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53E3E).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              context.read<dashboard.ReservationDashboardCubit>().refresh();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            tooltip: 'Actualizar datos',
          ),
        ),
      ],
    );
  }

  Widget _buildKPISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas del Mes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'MuseoSans',
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                title: 'Total Reservas',
                value: stats.totalThisMonth.toString(),
                icon: Icons.calendar_month,
                color: const Color(0xFF3B82F6),
                subtitle: 'Este mes',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKpiCard(
                title: 'Completadas',
                value: stats.completedThisMonth.toString(),
                icon: Icons.check_circle,
                color: const Color(0xFF10B981),
                subtitle: 'Exitosas',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKpiCard(
                title: 'Canceladas',
                value: stats.cancelledThisMonth.toString(),
                icon: Icons.cancel,
                color: const Color(0xFFEF4444),
                subtitle: 'Este mes',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKpiCard(
                title: 'Promedio Personas',
                value: stats.averagePartySize.toStringAsFixed(1),
                icon: Icons.people,
                color: const Color(0xFF8B5CF6),
                subtitle: 'Por reserva',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'MuseoSans',
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'MuseoSans',
              color: Color(0xFF374151),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'MuseoSans',
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
