import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Place model and PlaceRepository/PlaceService
// e.g., import 'package:core/models/place.dart';
// import 'package:core/repositories/place_repository.dart';
// import 'package:core/services/place_service.dart';


// --- Places States ---
abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<Place> places; // Place comes from turbo_core
  final int totalCount;
  final int currentPage;

  PlacesLoaded({
    required this.places,
    required this.totalCount,
    required this.currentPage,
  });
}

class PlacesError extends PlacesState {
  final String message;
  PlacesError(this.message);
}

// --- Places Cubit ---
class PlacesCubit extends Cubit<PlacesState> {
  final PlaceRepository _placeRepository;
  final PlaceService _placeService;

  PlacesCubit({
    PlaceRepository? placeRepository,
    PlaceService? placeService,
  }) : _placeRepository = placeRepository ?? GetIt.instance<PlaceRepository>(),
       _placeService = placeService ?? GetIt.instance<PlaceService>(),
       super(PlacesInitial());

  Future<void> loadPlaces({int page = 1, String? categoryId}) async {
    emit(PlacesLoading());
    try {
      List<Place> places;
      if (categoryId != null && categoryId.isNotEmpty) {
        places = await _placeRepository.getPlacesByCategory(categoryId);
      } else {
        places = await _placeRepository.getPlaces(); // Assuming this gets all or a page
      }
      // TODO: Implement actual pagination in repository if needed
      emit(PlacesLoaded(
        places: places,
        totalCount: places.length, // This would be different with actual pagination
        currentPage: page,
      ));
    } catch (e) {
      emit(PlacesError(e.toString()));
    }
  }

  Future<void> deletePlace(String placeId) async {
    // Keep current state or emit loading for delete action?
    // For now, let's assume we want to show a loading state on the list or refresh.
    // final previousState = state;
    // emit(PlacesLoading()); // Or a specific DeletingPlaceState
    try {
      await _placeService.deletePlace(placeId);
      // Reload places after deletion
      await loadPlaces(); 
      // Alternatively, if PlacesLoaded holds the list, remove it manually and re-emit
    } catch (e) {
      emit(PlacesError('Error al eliminar: ${e.toString()}'));
      // if (previousState is PlacesLoaded) emit(previousState); // Optionally revert
    }
  }
}
