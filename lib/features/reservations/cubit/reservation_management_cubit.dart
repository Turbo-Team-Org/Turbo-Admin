import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';

part 'reservation_management_cubit.freezed.dart';
part 'reservation_management_state.dart';

/// Cubit para la gestión completa de reservas
/// Maneja confirmación, rechazo, check-in, completar y no-show
class ReservationManagementCubit extends Cubit<ReservationManagementState>
    with BaseCubit {
  final ReservationRepository _reservationRepo;
  final String placeId;

  ReservationManagementCubit(this._reservationRepo, this.placeId)
      : super(const ReservationManagementState.initial());

  /// Cargar todas las reservas del lugar
  Future<void> loadReservations({
    ReservationStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    secureEmit(const ReservationManagementState.loading());

    try {
      List<Reservation> reservations;

      if (status != null) {
        reservations = await _reservationRepo.getPlaceReservations(placeId,
            status: status);
      } else if (startDate != null && endDate != null) {
        reservations = await _reservationRepo.getReservationsBetweenDates(
          placeId,
          startDate,
          endDate,
        );
      } else {
        reservations = await _reservationRepo.getPlaceReservations(placeId);
      }

      secureEmit(ReservationManagementState.loaded(reservations: reservations));
    } catch (e) {
      secureEmit(
          ReservationManagementState.error('Error cargando reservas: $e'));
    }
  }

  /// Confirmar una reserva
  Future<void> confirmReservation({
    required String reservationId,
    String? tableNumber,
    String? notes,
  }) async {
    final currentState = state;
    if (currentState is! ReservationManagementLoaded) return;

    secureEmit(currentState.copyWith(isProcessing: true));

    try {
      await _reservationRepo.confirmReservation(
        reservationId,
        tableNumber: tableNumber,
        notes: notes,
      );

      // Actualizar la reserva en el estado local
      final updatedReservations = currentState.reservations.map((r) {
        if (r.id == reservationId) {
          return r.copyWith(
            status: ReservationStatus.confirmed,
            tableNumber: tableNumber,
            adminNotes: notes,
          );
        }
        return r;
      }).toList();

      secureEmit(currentState.copyWith(
        reservations: updatedReservations,
        isProcessing: false,
        successMessage: 'Reserva confirmada exitosamente',
      ));
    } catch (e) {
      secureEmit(currentState.copyWith(
        isProcessing: false,
        errorMessage: 'Error confirmando reserva: $e',
      ));
    }
  }

  /// Rechazar una reserva
  Future<void> rejectReservation({
    required String reservationId,
    required String reason,
  }) async {
    final currentState = state;
    if (currentState is! ReservationManagementLoaded) return;

    secureEmit(currentState.copyWith(isProcessing: true));

    try {
      await _reservationRepo.rejectReservation(reservationId, reason: reason);

      // Actualizar la reserva en el estado local
      final updatedReservations = currentState.reservations.map((r) {
        if (r.id == reservationId) {
          return r.copyWith(
            status: ReservationStatus.rejected,
            cancelReason: reason,
            cancelledAt: DateTime.now(),
          );
        }
        return r;
      }).toList();

      secureEmit(currentState.copyWith(
        reservations: updatedReservations,
        isProcessing: false,
        successMessage: 'Reserva rechazada',
      ));
    } catch (e) {
      secureEmit(currentState.copyWith(
        isProcessing: false,
        errorMessage: 'Error rechazando reserva: $e',
      ));
    }
  }

  /// Check-in del cliente
  Future<void> checkInReservation({
    required String reservationId,
    String? notes,
  }) async {
    final currentState = state;
    if (currentState is! ReservationManagementLoaded) return;

    secureEmit(currentState.copyWith(isProcessing: true));

    try {
      await _reservationRepo.checkInReservation(reservationId, notes: notes);

      // Actualizar la reserva en el estado local
      final updatedReservations = currentState.reservations.map((r) {
        if (r.id == reservationId) {
          return r.copyWith(
            status: ReservationStatus.checkedIn,
            checkedInAt: DateTime.now(),
            adminNotes: notes,
          );
        }
        return r;
      }).toList();

      secureEmit(currentState.copyWith(
        reservations: updatedReservations,
        isProcessing: false,
        successMessage: 'Check-in realizado exitosamente',
      ));
    } catch (e) {
      secureEmit(currentState.copyWith(
        isProcessing: false,
        errorMessage: 'Error en check-in: $e',
      ));
    }
  }

  /// Completar una reserva
  Future<void> completeReservation({
    required String reservationId,
    String? notes,
  }) async {
    final currentState = state;
    if (currentState is! ReservationManagementLoaded) return;

    secureEmit(currentState.copyWith(isProcessing: true));

    try {
      await _reservationRepo.completeReservation(reservationId, notes: notes);

      // Actualizar la reserva en el estado local
      final updatedReservations = currentState.reservations.map((r) {
        if (r.id == reservationId) {
          return r.copyWith(
            status: ReservationStatus.completed,
            confirmedAt: DateTime.now(),
            adminNotes: notes,
          );
        }
        return r;
      }).toList();

      secureEmit(currentState.copyWith(
        reservations: updatedReservations,
        isProcessing: false,
        successMessage: 'Reserva completada exitosamente',
      ));
    } catch (e) {
      secureEmit(currentState.copyWith(
        isProcessing: false,
        errorMessage: 'Error completando reserva: $e',
      ));
    }
  }

  /// Marcar como no-show
  Future<void> markNoShow({
    required String reservationId,
    String? notes,
  }) async {
    final currentState = state;
    if (currentState is! ReservationManagementLoaded) return;

    secureEmit(currentState.copyWith(isProcessing: true));

    try {
      await _reservationRepo.markNoShow(reservationId, notes: notes);

      // Actualizar la reserva en el estado local
      final updatedReservations = currentState.reservations.map((r) {
        if (r.id == reservationId) {
          return r.copyWith(
            status: ReservationStatus.noShow,
            adminNotes: notes,
          );
        }
        return r;
      }).toList();

      secureEmit(currentState.copyWith(
        reservations: updatedReservations,
        isProcessing: false,
        successMessage: 'Marcado como no-show',
      ));
    } catch (e) {
      secureEmit(currentState.copyWith(
        isProcessing: false,
        errorMessage: 'Error marcando no-show: $e',
      ));
    }
  }

  /// Cancelar una reserva
  Future<void> cancelReservation({
    required String reservationId,
    String? reason,
  }) async {
    final currentState = state;
    if (currentState is! ReservationManagementLoaded) return;

    secureEmit(currentState.copyWith(isProcessing: true));

    try {
      await _reservationRepo.cancelReservation(reservationId, reason: reason);

      // Actualizar la reserva en el estado local
      final updatedReservations = currentState.reservations.map((r) {
        if (r.id == reservationId) {
          return r.copyWith(
            status: ReservationStatus.cancelled,
            cancelReason: reason,
            cancelledAt: DateTime.now(),
          );
        }
        return r;
      }).toList();

      secureEmit(currentState.copyWith(
        reservations: updatedReservations,
        isProcessing: false,
        successMessage: 'Reserva cancelada',
      ));
    } catch (e) {
      secureEmit(currentState.copyWith(
        isProcessing: false,
        errorMessage: 'Error cancelando reserva: $e',
      ));
    }
  }

  /// Filtrar reservas por estado
  void filterByStatus(ReservationStatus? status) {
    loadReservations(status: status);
  }

  /// Filtrar reservas por rango de fechas
  void filterByDateRange(DateTime startDate, DateTime endDate) {
    loadReservations(startDate: startDate, endDate: endDate);
  }

  /// Limpiar mensajes de estado
  void clearMessages() {
    final currentState = state;
    if (currentState is ReservationManagementLoaded) {
      secureEmit(currentState.copyWith(
        successMessage: null,
        errorMessage: null,
      ));
    }
  }

  /// Refrescar reservas
  Future<void> refresh() async {
    await loadReservations();
  }
}
