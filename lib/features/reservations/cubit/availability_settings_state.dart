part of 'availability_settings_cubit.dart';

/// Estados para la configuración de disponibilidad
@freezed
class AvailabilitySettingsState with _$AvailabilitySettingsState {
  /// Estado inicial
  const factory AvailabilitySettingsState.initial() =
      AvailabilitySettingsInitial;

  /// Estado de carga
  const factory AvailabilitySettingsState.loading() =
      AvailabilitySettingsLoading;

  /// Estado con datos cargados
  const factory AvailabilitySettingsState.loaded({
    BusinessAvailability? availability,
    @Default(false) bool isSaving,
    String? successMessage,
    String? errorMessage,
  }) = AvailabilitySettingsLoaded;

  /// Estado de error
  const factory AvailabilitySettingsState.error(String message) =
      AvailabilitySettingsError;
}
