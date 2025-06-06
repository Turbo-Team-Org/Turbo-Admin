import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart'; // For Place model and PlaceRepository/PlaceService
import 'package:turbo_admin/features/places/cubit/places_state.dart';

/// Cubit for managing places state and operations
class PlacesCubit extends Cubit<PlacesState> with BaseCubit {
  final PlaceRepository _placeRepository;

  PlacesCubit({
    required PlaceRepository placeRepository,
  })  : _placeRepository = placeRepository,
        super(PlacesInitial());

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
      // Reload places after deletion
      await loadPlaces();
    } catch (e) {
      secureEmit(PlacesError('Error al eliminar: ${e.toString()}'));
      if (previousState is PlacesLoaded) {
        secureEmit(previousState); // Optionally revert
      }
    }
  }
}
