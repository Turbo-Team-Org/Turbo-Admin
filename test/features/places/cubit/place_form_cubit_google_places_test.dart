import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';

// =====================================================================
// MOCKS
// =====================================================================

class MockLocationRepository extends Mock implements LocationRepository {}

class MockPlaceRepository extends Mock implements PlaceRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockPlaceCategoryRepository extends Mock
    implements PlaceCategoryRepositoryInterface {}

// Helpers ===============================================================

GooglePlace _fakeGooglePlace({
  String placeId = 'place_1',
  String name = 'Restaurante Obispo',
  String formattedAddress = 'Calle Obispo 123, La Habana',
  double latitude = 23.1367,
  double longitude = -82.3589,
}) {
  return GooglePlace(
    placeId: placeId,
    name: name,
    formattedAddress: formattedAddress,
    location: LocationData(latitude: latitude, longitude: longitude),
  );
}

PlaceFormCubit _buildCubit({
  required LocationRepository locationRepository,
  PlaceRepository? placeRepository,
  CategoryRepository? categoryRepository,
  PlaceCategoryRepositoryInterface? placeCategoryRepository,
}) {
  return PlaceFormCubit(
    placeRepository: placeRepository ?? MockPlaceRepository(),
    categoryRepository: categoryRepository ?? MockCategoryRepository(),
    placeCategoryRepository:
        placeCategoryRepository ?? MockPlaceCategoryRepository(),
    locationRepository: locationRepository,
  );
}

// Loaded state base (sin sugerencias) que usaremos como punto de partida
PlaceFormLoaded _baseLoaded() => const PlaceFormLoaded(
      place: null,
      categories: <Category>[],
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_fakeGooglePlace());
  });

  group('PlaceFormCubit · Google Places autocomplete', () {
    late MockLocationRepository locationRepo;

    setUp(() {
      locationRepo = MockLocationRepository();
    });

    blocTest<PlaceFormCubit, PlaceFormState>(
      'onAddressInputChanged dispara loading -> success con sugerencias '
      '(debounce + una sola llamada al repo)',
      build: () {
        when(
          () => locationRepo.autocompletePlaces(
            input: any(named: 'input'),
            location: any(named: 'location'),
            radius: any(named: 'radius'),
          ),
        ).thenAnswer(
          (_) async => [
            _fakeGooglePlace(),
            _fakeGooglePlace(placeId: 'p2', name: 'Bar Obispo'),
          ],
        );
        return _buildCubit(locationRepository: locationRepo);
      },
      seed: _baseLoaded,
      act: (cubit) async {
        // Simula tipeo rápido — todas las llamadas deben colapsar a 1 sola
        // por el debounce.
        cubit.onAddressInputChanged('Obi');
        cubit.onAddressInputChanged('Obis');
        cubit.onAddressInputChanged('Obisp');
        cubit.onAddressInputChanged('Obispo');
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      expect: () => [
        isA<PlaceFormLoaded>()
            .having((s) => s.isAutocompleteLoading, 'loading', true)
            .having((s) => s.autocompleteError, 'error', isNull),
        isA<PlaceFormLoaded>()
            .having((s) => s.isAutocompleteLoading, 'loading', false)
            .having(
              (s) => s.autocompleteSuggestions,
              'suggestions',
              hasLength(2),
            )
            .having((s) => s.autocompleteError, 'error', isNull),
      ],
      verify: (_) {
        verify(
          () => locationRepo.autocompletePlaces(
            input: 'Obispo',
            location: any(named: 'location'),
            radius: any(named: 'radius'),
          ),
        ).called(1);
      },
    );

    blocTest<PlaceFormCubit, PlaceFormState>(
      'onAddressInputChanged con input.length < 3 no llama al repo y '
      'limpia sugerencias',
      build: () => _buildCubit(locationRepository: locationRepo),
      seed: () => PlaceFormLoaded(
        place: null,
        categories: const <Category>[],
        autocompleteSuggestions: [_fakeGooglePlace()],
      ),
      act: (cubit) async {
        cubit.onAddressInputChanged('ab');
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      expect: () => [
        isA<PlaceFormLoaded>()
            .having(
              (s) => s.autocompleteSuggestions,
              'suggestions',
              isEmpty,
            )
            .having((s) => s.isAutocompleteLoading, 'loading', false)
            .having((s) => s.autocompleteError, 'error', isNull),
      ],
      verify: (_) {
        verifyNever(
          () => locationRepo.autocompletePlaces(
            input: any(named: 'input'),
            location: any(named: 'location'),
            radius: any(named: 'radius'),
          ),
        );
      },
    );

    blocTest<PlaceFormCubit, PlaceFormState>(
      'error del repo en autocompletado emite autocompleteError y '
      'NO destruye place/categories del estado',
      build: () {
        when(
          () => locationRepo.autocompletePlaces(
            input: any(named: 'input'),
            location: any(named: 'location'),
            radius: any(named: 'radius'),
          ),
        ).thenThrow(Exception('network down'));
        return _buildCubit(locationRepository: locationRepo);
      },
      seed: () => const PlaceFormLoaded(
        place: null,
        categories: <Category>[],
      ),
      act: (cubit) async {
        cubit.onAddressInputChanged('Habana');
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      expect: () => [
        isA<PlaceFormLoaded>()
            .having((s) => s.isAutocompleteLoading, 'loading', true),
        isA<PlaceFormLoaded>()
            .having((s) => s.isAutocompleteLoading, 'loading', false)
            .having(
              (s) => s.autocompleteError,
              'error',
              isNotNull,
            )
            .having(
              (s) => s.autocompleteSuggestions,
              'suggestions',
              isEmpty,
            ),
      ],
    );

    blocTest<PlaceFormCubit, PlaceFormState>(
      'onAddressSuggestionSelected propaga address + coords y limpia sugerencias',
      build: () => _buildCubit(locationRepository: locationRepo),
      seed: () => PlaceFormLoaded(
        place: null,
        categories: const <Category>[],
        autocompleteSuggestions: [
          _fakeGooglePlace(),
          _fakeGooglePlace(placeId: 'p2', name: 'Bar Obispo'),
        ],
      ),
      act: (cubit) async {
        await cubit.onAddressSuggestionSelected(_fakeGooglePlace());
      },
      expect: () => [
        isA<PlaceFormLoaded>()
            .having(
              (s) => s.selectedAddress,
              'address',
              'Calle Obispo 123, La Habana',
            )
            .having((s) => s.selectedLatitude, 'lat', 23.1367)
            .having((s) => s.selectedLongitude, 'lng', -82.3589)
            .having(
              (s) => s.autocompleteSuggestions,
              'suggestions',
              isEmpty,
            ),
      ],
      verify: (_) {
        verifyNever(() => locationRepo.getPlaceDetails(any()));
      },
    );

    blocTest<PlaceFormCubit, PlaceFormState>(
      'onAddressSuggestionSelected sin coords válidas resuelve vía '
      'getPlaceDetails(placeId)',
      build: () {
        when(() => locationRepo.getPlaceDetails('place_x')).thenAnswer(
          (_) async => _fakeGooglePlace(
            placeId: 'place_x',
            latitude: 41.0,
            longitude: 2.0,
          ),
        );
        return _buildCubit(locationRepository: locationRepo);
      },
      seed: () => const PlaceFormLoaded(
        place: null,
        categories: <Category>[],
      ),
      act: (cubit) async {
        await cubit.onAddressSuggestionSelected(
          _fakeGooglePlace(
            placeId: 'place_x',
            latitude: 0.0,
            longitude: 0.0,
          ),
        );
      },
      expect: () => [
        isA<PlaceFormLoaded>()
            .having((s) => s.selectedLatitude, 'lat', 41.0)
            .having((s) => s.selectedLongitude, 'lng', 2.0),
      ],
      verify: (_) {
        verify(() => locationRepo.getPlaceDetails('place_x')).called(1);
      },
    );
  });
}
