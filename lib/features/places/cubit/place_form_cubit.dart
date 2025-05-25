import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Place, Category models and related Repos/Services
// e.g., import 'package:core/models/place.dart';
// import 'package:core/models/category.dart';
// import 'package:core/repositories/category_repository.dart';
// import 'package:core/repositories/place_repository.dart';
// import 'package:core/services/place_service.dart';

// --- PlaceForm States ---
abstract class PlaceFormState {}

class PlaceFormInitial extends PlaceFormState {}

class PlaceFormLoading extends PlaceFormState {}

class PlaceFormLoaded extends PlaceFormState {
  final Place? place; // null for create, Place for edit
  final List<Category> categories; // From turbo_core

  PlaceFormLoaded({this.place, required this.categories});
}

class PlaceFormSaving extends PlaceFormState {}

class PlaceFormSuccess extends PlaceFormState {}

class PlaceFormError extends PlaceFormState {
  final String message;
  PlaceFormError(this.message);
}

// --- PlaceForm Cubit ---
class PlaceFormCubit extends Cubit<PlaceFormState> {
  final PlaceRepository _placeRepository;
  final CategoryRepository _categoryRepository;
  final PlaceService _placeService;

  PlaceFormCubit({
    PlaceRepository? placeRepository,
    CategoryRepository? categoryRepository,
    PlaceService? placeService,
  }) : _placeRepository = placeRepository ?? GetIt.instance<PlaceRepository>(),
       _categoryRepository = categoryRepository ?? GetIt.instance<CategoryRepository>(),
       _placeService = placeService ?? GetIt.instance<PlaceService>(),
       super(PlaceFormInitial());

  Future<void> loadForm({String? placeId}) async {
    emit(PlaceFormLoading());
    try {
      final categories = await _categoryRepository.getCategories();
      Place? place;
      if (placeId != null && placeId.isNotEmpty) {
        place = await _placeRepository.getPlaceById(placeId);
      }
      emit(PlaceFormLoaded(place: place, categories: categories));
    } catch (e) {
      emit(PlaceFormError(e.toString()));
    }
  }

  Future<void> savePlace(Place place) async {
    emit(PlaceFormSaving());
    try {
      // Assuming Place model has an 'id' field.
      // And new places might have an empty or specific ID marker.
      // The issue implies `place.id.isEmpty` for new places.
      if (place.id.isEmpty) { 
        await _placeService.addPlace(place);
      } else {
        await _placeService.updatePlace(place);
      }
      emit(PlaceFormSuccess());
    } catch (e) {
      emit(PlaceFormError('Error al guardar: ${e.toString()}'));
    }
  }
}
