part of 'reservation_management_cubit.dart';

/// Estados para la gestión de reservas
@freezed
class ReservationManagementState with _$ReservationManagementState {
  /// Estado inicial
  const factory ReservationManagementState.initial() =
      ReservationManagementInitial;

  /// Estado de carga
  const factory ReservationManagementState.loading() =
      ReservationManagementLoading;

  /// Estado con datos cargados
  const factory ReservationManagementState.loaded({
    required List<Reservation> reservations,
    @Default(false) bool isProcessing,
    String? successMessage,
    String? errorMessage,
  }) = ReservationManagementLoaded;

  /// Estado de error
  const factory ReservationManagementState.error(String message) =
      ReservationManagementError;
}
