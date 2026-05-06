import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';

part 'availability_settings_cubit.freezed.dart';
part 'availability_settings_state.dart';

/// Cubit para la configuración de disponibilidad y horarios
/// Maneja horarios semanales, días especiales y fechas bloqueadas
class AvailabilitySettingsCubit extends Cubit<AvailabilitySettingsState>
    with BaseCubit {
  final ReservationRepository _reservationRepo;
  final String placeId;

  AvailabilitySettingsCubit(this._reservationRepo, this.placeId)
      : super(const AvailabilitySettingsState.initial());

  /// Cargar configuración actual de disponibilidad
  Future<void> loadCurrentAvailability() async {
    secureEmit(const AvailabilitySettingsState.loading());

    try {
      final availability =
          await _reservationRepo.getBusinessAvailability(placeId);
      secureEmit(AvailabilitySettingsState.loaded(availability: availability));
    } catch (e) {
      secureEmit(
          AvailabilitySettingsState.error('Error cargando disponibilidad: $e'));
    }
  }

  /// Configurar disponibilidad básica (primera vez)
  Future<void> setupBasicAvailability({
    required String openTime,
    required String closeTime,
    required List<int> closedDays,
    required int maxCapacityPerSlot,
  }) async {
    final currentState = state;
    if (currentState is! AvailabilitySettingsLoaded) return;

    secureEmit(currentState.copyWith(isSaving: true));

    try {
      await _reservationRepo.setupBasicAvailability(
        placeId: placeId,
        createdBy: 'admin_user_id', // TODO: Obtener del auth context
        openTime: openTime,
        closeTime: closeTime,
        closedDays: closedDays,
        maxCapacityPerSlot: maxCapacityPerSlot,
      );

      secureEmit(currentState.copyWith(
        isSaving: false,
        successMessage: 'Disponibilidad configurada exitosamente',
      ));

      await loadCurrentAvailability();
    } catch (e) {
      secureEmit(currentState.copyWith(
        isSaving: false,
        errorMessage: 'Error configurando disponibilidad: $e',
      ));
    }
  }

  /// Actualizar horarios semanales
  Future<void> updateWeeklySchedule(List<WeeklySchedule> schedule) async {
    final currentState = state;
    if (currentState is! AvailabilitySettingsLoaded) return;

    secureEmit(currentState.copyWith(isSaving: true));

    try {
      await _reservationRepo.updateWeeklySchedule(placeId, schedule);

      secureEmit(currentState.copyWith(
        isSaving: false,
        successMessage: 'Horarios actualizados exitosamente',
      ));

      await loadCurrentAvailability();
    } catch (e) {
      secureEmit(currentState.copyWith(
        isSaving: false,
        errorMessage: 'Error actualizando horarios: $e',
      ));
    }
  }

  /// Agregar día especial
  Future<void> addSpecialDay(SpecialDay specialDay) async {
    final currentState = state;
    if (currentState is! AvailabilitySettingsLoaded) return;

    secureEmit(currentState.copyWith(isSaving: true));

    try {
      await _reservationRepo.addSpecialDay(placeId, specialDay);

      secureEmit(currentState.copyWith(
        isSaving: false,
        successMessage: 'Día especial agregado exitosamente',
      ));

      await loadCurrentAvailability();
    } catch (e) {
      secureEmit(currentState.copyWith(
        isSaving: false,
        errorMessage: 'Error agregando día especial: $e',
      ));
    }
  }

  /// Bloquear fechas
  Future<void> addBlackoutDate(BlackoutDate blackoutDate) async {
    final currentState = state;
    if (currentState is! AvailabilitySettingsLoaded) return;

    secureEmit(currentState.copyWith(isSaving: true));

    try {
      await _reservationRepo.addBlackoutDate(placeId, blackoutDate);

      secureEmit(currentState.copyWith(
        isSaving: false,
        successMessage: 'Fecha bloqueada exitosamente',
      ));

      await loadCurrentAvailability();
    } catch (e) {
      secureEmit(currentState.copyWith(
        isSaving: false,
        errorMessage: 'Error bloqueando fecha: $e',
      ));
    }
  }

  /// Eliminar día especial
  Future<void> removeSpecialDay(String specialDayId) async {
    final currentState = state;
    if (currentState is! AvailabilitySettingsLoaded) return;

    secureEmit(currentState.copyWith(isSaving: true));

    try {
      await _reservationRepo.removeBlackoutDate(placeId, specialDayId);

      secureEmit(currentState.copyWith(
        isSaving: false,
        successMessage: 'Día especial eliminado',
      ));

      await loadCurrentAvailability();
    } catch (e) {
      secureEmit(currentState.copyWith(
        isSaving: false,
        errorMessage: 'Error eliminando día especial: $e',
      ));
    }
  }

  /// Eliminar fecha bloqueada
  Future<void> removeBlackoutDate(String blackoutDateId) async {
    final currentState = state;
    if (currentState is! AvailabilitySettingsLoaded) return;

    secureEmit(currentState.copyWith(isSaving: true));

    try {
      await _reservationRepo.removeBlackoutDate(placeId, blackoutDateId);

      secureEmit(currentState.copyWith(
        isSaving: false,
        successMessage: 'Fecha desbloqueada',
      ));

      await loadCurrentAvailability();
    } catch (e) {
      secureEmit(currentState.copyWith(
        isSaving: false,
        errorMessage: 'Error desbloqueando fecha: $e',
      ));
    }
  }

  /// Limpiar mensajes de estado
  void clearMessages() {
    final currentState = state;
    if (currentState is AvailabilitySettingsLoaded) {
      secureEmit(currentState.copyWith(
        successMessage: null,
        errorMessage: null,
      ));
    }
  }

  /// Refrescar configuración
  Future<void> refresh() async {
    await loadCurrentAvailability();
  }
}
