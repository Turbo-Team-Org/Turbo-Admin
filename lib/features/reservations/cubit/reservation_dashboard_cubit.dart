import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';

part 'reservation_dashboard_cubit.freezed.dart';
part 'reservation_dashboard_state.dart';

/// Cubit para el dashboard principal de reservas
/// Maneja métricas, reservas del día y actualizaciones en tiempo real
class ReservationDashboardCubit extends Cubit<ReservationDashboardState>
    with BaseCubit {
  final ReservationRepository _reservationRepo;
  final String placeId;

  ReservationDashboardCubit(this._reservationRepo, this.placeId)
      : super(const ReservationDashboardState.initial());

  /// Cargar dashboard completo con todas las métricas
  Future<void> loadDashboard() async {
    secureEmit(const ReservationDashboardState.loading());

    try {
      // Cargar datos en paralelo para mejor performance
      final results = await Future.wait([
        _reservationRepo.getTodayReservations(placeId),
        _reservationRepo.getPlaceReservations(placeId,
            status: ReservationStatus.pending),
        _reservationRepo.getReservationsBetweenDates(
          placeId,
          DateTime.now(),
          DateTime.now().add(const Duration(days: 7)),
        ),
        _getReservationStats(),
      ]);

      final todayReservations = results[0] as List<Reservation>;
      final pendingReservations = results[1] as List<Reservation>;
      final weekReservations = results[2] as List<Reservation>;
      final stats = results[3] as ReservationStats;

      secureEmit(ReservationDashboardState.loaded(
        todayReservations: todayReservations,
        pendingReservations: pendingReservations,
        weekReservations: weekReservations,
        stats: stats,
      ));
    } catch (e) {
      secureEmit(
          ReservationDashboardState.error('Error cargando dashboard: $e'));
    }
  }

  /// Iniciar actualizaciones en tiempo real
  void startRealtimeUpdates() {
    _reservationRepo.watchPlaceReservations(placeId).listen(
      (reservations) {
        final currentState = state;
        if (currentState is ReservationDashboardLoaded) {
          secureEmit(currentState.copyWith(allReservations: reservations));
        }
      },
      onError: (error) {
        secureEmit(
            ReservationDashboardState.error('Error en tiempo real: $error'));
      },
    );
  }

  /// Refrescar datos del dashboard
  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Calcular estadísticas del mes actual
  Future<ReservationStats> _getReservationStats() async {
    try {
      final today = DateTime.now();
      final startOfMonth = DateTime(today.year, today.month, 1);

      final monthReservations =
          await _reservationRepo.getReservationsBetweenDates(
        placeId,
        startOfMonth,
        today,
      );

      if (monthReservations.isEmpty) {
        return const ReservationStats(
          totalThisMonth: 0,
          completedThisMonth: 0,
          cancelledThisMonth: 0,
          averagePartySize: 0.0,
        );
      }

      final completed = monthReservations
          .where((r) => r.status == ReservationStatus.completed)
          .length;
      final cancelled = monthReservations
          .where((r) => r.status == ReservationStatus.cancelled)
          .length;
      final totalPartySize =
          monthReservations.map((r) => r.partySize).reduce((a, b) => a + b);
      final averagePartySize = totalPartySize / monthReservations.length;

      return ReservationStats(
        totalThisMonth: monthReservations.length,
        completedThisMonth: completed,
        cancelledThisMonth: cancelled,
        averagePartySize: averagePartySize,
      );
    } catch (e) {
      return const ReservationStats(
        totalThisMonth: 0,
        completedThisMonth: 0,
        cancelledThisMonth: 0,
        averagePartySize: 0.0,
      );
    }
  }

  /// Obtener reservas urgentes (próximas 2 horas)
  List<Reservation> getUrgentReservations() {
    final currentState = state;
    if (currentState is ReservationDashboardLoaded) {
      final now = DateTime.now();
      final urgentThreshold = now.add(const Duration(hours: 2));

      return currentState.todayReservations
          .where((reservation) =>
              reservation.status == ReservationStatus.pending &&
              reservation.startTime.isBefore(urgentThreshold) &&
              reservation.startTime.isAfter(now))
          .toList();
    }
    return [];
  }

  /// Obtener ocupación actual estimada
  double getCurrentOccupancy() {
    final currentState = state;
    if (currentState is ReservationDashboardLoaded) {
      final now = DateTime.now();
      final currentReservations = currentState.todayReservations
          .where((r) =>
              r.status == ReservationStatus.confirmed &&
              r.startTime.isBefore(now) &&
              r.endTime.isAfter(now))
          .toList();

      // Estimación básica - en producción se podría usar capacidad real del lugar
      final totalCurrentGuests =
          currentReservations.map((r) => r.partySize).fold(0, (a, b) => a + b);

      // Asumiendo capacidad máxima de 100 personas (configurable)
      const maxCapacity = 100;
      return (totalCurrentGuests / maxCapacity).clamp(0.0, 1.0);
    }
    return 0.0;
  }
}
