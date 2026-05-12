import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_form_state.freezed.dart';

/// Estado del formulario de creación/edición de lugares.
///
/// Modelado como `sealed` para forzar `switch` exhaustivo en la UI y como
/// `freezed` para tener `copyWith` con soporte real de `null` sin sentinels
/// manuales. Las claves del autocompletado (sugerencias, loading, error y
/// selección consolidada) viven dentro de [PlaceFormLoaded] para mantener la
/// transición de estados localizada y permitir reusar el form mientras el
/// usuario navega entre tipear y seleccionar.
@freezed
sealed class PlaceFormState with _$PlaceFormState {
  const factory PlaceFormState.initial() = PlaceFormInitial;

  const factory PlaceFormState.loading() = PlaceFormLoading;

  const factory PlaceFormState.loaded({
    required List<Category> categories,
    Place? place,
    @Default(<GooglePlace>[]) List<GooglePlace> autocompleteSuggestions,
    @Default(false) bool isAutocompleteLoading,
    String? autocompleteError,
    String? selectedAddress,
    double? selectedLatitude,
    double? selectedLongitude,
  }) = PlaceFormLoaded;

  const factory PlaceFormState.saving() = PlaceFormSaving;

  const factory PlaceFormState.success({required bool isNewPlace}) =
      PlaceFormSuccess;

  const factory PlaceFormState.error(String message) = PlaceFormError;
}
