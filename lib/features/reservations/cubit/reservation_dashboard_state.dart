part of 'reservation_dashboard_cubit.dart';

/// Estados para el dashboard de reservas
@freezed
class ReservationDashboardState with _$ReservationDashboardState {
  /// Estado inicial
  const factory ReservationDashboardState.initial() =
      ReservationDashboardInitial;

  /// Estado de carga
  const factory ReservationDashboardState.loading() =
      ReservationDashboardLoading;

  /// Estado con datos cargados
  const factory ReservationDashboardState.loaded({
    required List<Reservation> todayReservations,
    required List<Reservation> pendingReservations,
    required List<Reservation> weekReservations,
    required ReservationStats stats,
    @Default([]) List<Reservation> allReservations,
  }) = ReservationDashboardLoaded;

  /// Estado de error
  const factory ReservationDashboardState.error(String message) =
      ReservationDashboardError;
}

/// Modelo de estadísticas de reservas
@freezed
sealed class ReservationStats with _$ReservationStats {
  const factory ReservationStats({
    required int totalThisMonth,
    required int completedThisMonth,
    required int cancelledThisMonth,
    required double averagePartySize,
  }) = _ReservationStats;
}
