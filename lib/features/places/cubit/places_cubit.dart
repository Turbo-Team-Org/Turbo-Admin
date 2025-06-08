import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart'; // For Place model and PlaceRepository/PlaceService
import 'package:turbo_admin/features/places/cubit/places_state.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';

/// Cubit for managing places state and operations
class PlacesCubit extends Cubit<PlacesState> with BaseCubit {
  final PlaceRepository _placeRepository;
  final PlaceFormCubit _placeFormCubit;
  StreamSubscription? _placeSavedSubscription;

  PlacesCubit({
    required PlaceRepository placeRepository,
    required PlaceFormCubit placeFormCubit,
  })  : _placeRepository = placeRepository,
        _placeFormCubit = placeFormCubit,
        super(PlacesInitial()) {
    _placeSavedSubscription = _placeFormCubit.onPlaceSaved.listen((_) {
      loadPlaces(); // Reload places when a place is saved
    });
  }

  @override
  Future<void> close() {
    _placeSavedSubscription?.cancel();
    return super.close();
  }

  Future<void> loadPlaces({int page = 1, String? categoryId}) async {
    secureEmit(PlacesLoading());
    try {
      List<Place> places;
      if (categoryId != null && categoryId.isNotEmpty) {
        places = await _placeRepository.getPlacesByCategory(categoryId);
      } else {
        places = await _placeRepository.getPlaces();
      }
      // TODO: Implement actual pagination in repository if needed
      secureEmit(PlacesLoaded(
        places: places,
        totalCount:
            places.length, // This would be different with actual pagination
        currentPage: page,
      ));
    } catch (e) {
      secureEmit(PlacesError(e.toString()));
    }
  }

  Future<void> deletePlace(String placeId) async {
    final previousState = state;
    secureEmit(PlacesLoading());
    try {
      await _placeRepository.deletePlace(placeId);
      // Si el estado anterior era PlacesLoaded, actualizamos la lista sin recargar
      if (previousState is PlacesLoaded) {
        final updatedPlaces =
            previousState.places.where((p) => p.id != placeId).toList();
        secureEmit(PlacesLoaded(
          places: updatedPlaces,
          totalCount: updatedPlaces.length,
          currentPage: previousState.currentPage,
        ));
      } else {
        // Si no teníamos lugares cargados, recargamos
        await loadPlaces();
      }
    } catch (e) {
      secureEmit(PlacesError('Error al eliminar: ${e.toString()}'));
      if (previousState is PlacesLoaded) {
        secureEmit(
            previousState); // Revertimos al estado anterior en caso de error
      }
    }
  }
}
