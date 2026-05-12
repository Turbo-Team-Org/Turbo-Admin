import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:get_it/get_it.dart';

/// Tiempo de espera entre teclas antes de disparar el autocompletado contra
/// `LocationRepository`. Suficiente para colapsar tipeo humano y mantener la
/// cuota de Google Places acotada.
@visibleForTesting
const Duration kPlaceAutocompleteDebounce = Duration(milliseconds: 300);

/// Mínimo de caracteres para invocar la API de Places. Evita peticiones con
/// poco contexto (que devolverían resultados ruidosos) y reduce coste.
const int _kMinAutocompleteChars = 3;

/// Cubit for managing place form state and operations.
class PlaceFormCubit extends Cubit<PlaceFormState> with BaseCubit {
  final PlaceRepository _placeRepository;
  final CategoryRepository _categoryRepository;
  final PlaceCategoryRepositoryInterface _placeCategoryRepository;
  final LocationRepository _locationRepository;
  final _placeSavedController = StreamController<void>.broadcast();

  Timer? _autocompleteDebounce;

  /// Contador monótono para descartar respuestas "obsoletas" cuando el usuario
  /// sigue tipeando. Cada disparo incrementa este id; al volver la respuesta
  /// solo se aplica si su id coincide con el último emitido.
  int _autocompleteRequestId = 0;

  Stream<void> get onPlaceSaved => _placeSavedController.stream;

  PlaceFormCubit({
    required PlaceRepository placeRepository,
    required CategoryRepository categoryRepository,
    required PlaceCategoryRepositoryInterface placeCategoryRepository,
    required LocationRepository locationRepository,
  })  : _placeRepository = placeRepository,
        _categoryRepository = categoryRepository,
        _placeCategoryRepository = placeCategoryRepository,
        _locationRepository = locationRepository,
        super(const PlaceFormState.initial());

  @override
  Future<void> close() {
    _autocompleteDebounce?.cancel();
    _placeSavedController.close();
    return super.close();
  }

  /// Limpia el estado del cubit para prepararlo para una nueva carga
  void clearState() {
    debugPrint('🔄 PlaceFormCubit: Limpiando estado anterior');
    _autocompleteDebounce?.cancel();
    secureEmit(const PlaceFormState.initial());
  }

  Future<void> loadFormData({String? placeId}) async {
    debugPrint('🔄 PlaceFormCubit: Iniciando carga de datos...');
    debugPrint('📍 PlaceFormCubit: placeId = $placeId');

    secureEmit(const PlaceFormState.initial());
    secureEmit(const PlaceFormState.loading());

    try {
      debugPrint('🔄 PlaceFormCubit: Cargando categorías...');
      final categories = await _categoryRepository.getAllCategories();
      debugPrint('✅ PlaceFormCubit: Categorías cargadas: ${categories.length}');

      if (placeId != null && placeId.isNotEmpty) {
        debugPrint('🔄 PlaceFormCubit: Cargando lugar con ID: $placeId');
        final place = await _placeRepository.getPlaceById(placeId);
        debugPrint('✅ PlaceFormCubit: Lugar cargado: ${place.name}');
        secureEmit(PlaceFormState.loaded(
          place: place,
          categories: categories,
        ));
      } else {
        debugPrint('ℹ️ PlaceFormCubit: Creando nuevo lugar');
        secureEmit(PlaceFormState.loaded(
          categories: categories,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ PlaceFormCubit: Error al cargar datos: $e');
      debugPrint('📍 StackTrace: $stackTrace');

      if (placeId != null && placeId.isNotEmpty) {
        secureEmit(PlaceFormState.error(
            'No se pudo cargar el lugar con ID: $placeId. Error: ${e.toString()}'));
      } else {
        secureEmit(PlaceFormState.error(
            'Error al cargar los datos del formulario: ${e.toString()}'));
      }
    }
  }

  // ========================================================================
  // Google Places autocomplete
  // ========================================================================

  /// Maneja el cambio de texto del campo "dirección".
  ///
  /// - Si el texto tiene menos de [_kMinAutocompleteChars] caracteres, cancela
  ///   cualquier petición pendiente y limpia el estado de sugerencias.
  /// - En caso contrario, debouncea la llamada al `LocationRepository` y
  ///   descarta respuestas obsoletas usando [_autocompleteRequestId].
  Future<void> onAddressInputChanged(String input) async {
    final loaded = _currentLoadedOrNull();
    if (loaded == null) return;

    _autocompleteDebounce?.cancel();
    final trimmed = input.trim();

    if (trimmed.length < _kMinAutocompleteChars) {
      _autocompleteRequestId++;
      secureEmit(loaded.copyWith(
        autocompleteSuggestions: const <GooglePlace>[],
        isAutocompleteLoading: false,
        autocompleteError: null,
      ));
      return;
    }

    _autocompleteDebounce = Timer(kPlaceAutocompleteDebounce, () {
      _runAutocomplete(trimmed);
    });
  }

  Future<void> _runAutocomplete(String query) async {
    final base = _currentLoadedOrNull();
    if (base == null) return;

    final requestId = ++_autocompleteRequestId;
    secureEmit(base.copyWith(
      isAutocompleteLoading: true,
      autocompleteError: null,
    ));

    try {
      final results =
          await _locationRepository.autocompletePlaces(input: query);

      if (requestId != _autocompleteRequestId) {
        return;
      }

      final after = _currentLoadedOrNull();
      if (after == null) return;
      secureEmit(after.copyWith(
        autocompleteSuggestions: results,
        isAutocompleteLoading: false,
        autocompleteError: null,
      ));
    } catch (e, stackTrace) {
      debugPrint('❌ PlaceFormCubit: Error en autocomplete: $e');
      debugPrint('📍 StackTrace: $stackTrace');

      if (requestId != _autocompleteRequestId) {
        return;
      }

      final after = _currentLoadedOrNull();
      if (after == null) return;
      secureEmit(after.copyWith(
        autocompleteSuggestions: const <GooglePlace>[],
        isAutocompleteLoading: false,
        autocompleteError: 'No se pudieron cargar sugerencias: ${e.toString()}',
      ));
    }
  }

  /// El usuario eligió una sugerencia. Si la coord viene a 0/0 (sin geometría
  /// resuelta), pedimos detalles al repo para completarla; si tampoco
  /// devuelve nada usamos 0/0 como fallback "no resuelto" para no bloquear UI.
  Future<void> onAddressSuggestionSelected(GooglePlace suggestion) async {
    final loaded = _currentLoadedOrNull();
    if (loaded == null) return;

    double latitude = suggestion.location.latitude;
    double longitude = suggestion.location.longitude;

    final coordsMissing = latitude == 0.0 && longitude == 0.0;
    if (coordsMissing) {
      try {
        final details =
            await _locationRepository.getPlaceDetails(suggestion.placeId);
        if (details != null) {
          latitude = details.location.latitude;
          longitude = details.location.longitude;
        }
      } catch (e, stackTrace) {
        debugPrint('❌ PlaceFormCubit: Error en getPlaceDetails: $e');
        debugPrint('📍 StackTrace: $stackTrace');
      }
    }

    final after = _currentLoadedOrNull() ?? loaded;
    secureEmit(after.copyWith(
      selectedAddress: suggestion.formattedAddress,
      selectedLatitude: latitude,
      selectedLongitude: longitude,
      autocompleteSuggestions: const <GooglePlace>[],
      isAutocompleteLoading: false,
      autocompleteError: null,
    ));
  }

  PlaceFormLoaded? _currentLoadedOrNull() {
    final s = state;
    return s is PlaceFormLoaded ? s : null;
  }

  /// Obtiene la ubicación actual del dispositivo vía `LocationRepository`.
  ///
  /// Devuelve `null` si el repo lanza error o el usuario no concede permisos.
  /// La UI debe mantener un fallback razonable (mapa centrado, sin marker).
  Future<LocationData?> getUserLocation() async {
    try {
      return await _locationRepository.getCurrentLocation();
    } catch (e, stackTrace) {
      debugPrint('❌ PlaceFormCubit: Error en getUserLocation: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      return null;
    }
  }

  // ========================================================================
  // Persistencia
  // ========================================================================

  Future<void> savePlace(Place place) async {
    secureEmit(const PlaceFormState.saving());
    try {
      final isNewPlace = place.id.isEmpty;
      final adminAuthCubit = GetIt.instance<AdminAuthCubit>();
      final currentAdmin = adminAuthCubit.currentAdminUser;

      if (currentAdmin == null) {
        throw Exception('No hay un administrador autenticado');
      }

      String placeId = place.id;
      if (isNewPlace) {
        placeId = (await _placeRepository.addPlace(place)) as String;

        final updatedOwnedPlaceIds = [...currentAdmin.ownedPlaceIds, placeId];
        await adminAuthCubit.updateOwnedPlaces(updatedOwnedPlaceIds);

        if (place.categoryId.isNotEmpty) {
          await _placeCategoryRepository.upsertPlaceCategory(
            PlaceCategory(
              placeId: placeId,
              categoryId: place.categoryId,
              createdAt: DateTime.now(),
            ),
          );
        }
      } else {
        final success = await _placeRepository.updatePlace(place);
        if (!success) {
          throw Exception('Error al actualizar el lugar');
        }
      }

      secureEmit(PlaceFormState.success(isNewPlace: isNewPlace));
      _placeSavedController.add(null);
    } catch (e) {
      secureEmit(PlaceFormState.error(e.toString()));
    }
  }
}
