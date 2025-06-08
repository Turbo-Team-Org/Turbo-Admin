import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:get_it/get_it.dart';
// e.g., import 'package:core/models/place.dart';
// import 'package:core/models/category.dart';
// import 'package:core/repositories/category_repository.dart';
// import 'package:core/repositories/place_repository.dart';
// import 'package:core/services/place_service.dart';

/// Cubit for managing place form state and operations
class PlaceFormCubit extends Cubit<PlaceFormState> with BaseCubit {
  final PlaceRepository _placeRepository;
  final CategoryRepository _categoryRepository;
  final _placeSavedController = StreamController<void>.broadcast();

  Stream<void> get onPlaceSaved => _placeSavedController.stream;

  PlaceFormCubit({
    required PlaceRepository placeRepository,
    required CategoryRepository categoryRepository,
  })  : _placeRepository = placeRepository,
        _categoryRepository = categoryRepository,
        super(PlaceFormInitial());

  @override
  Future<void> close() {
    _placeSavedController.close();
    return super.close();
  }

  Future<void> loadFormData({String? placeId}) async {
    debugPrint('🔄 PlaceFormCubit: Iniciando carga de datos...');
    debugPrint('📍 PlaceFormCubit: placeId = $placeId');
    secureEmit(PlaceFormLoading());
    try {
      debugPrint('🔄 PlaceFormCubit: Cargando categorías...');
      final categories = await _categoryRepository.getAllCategories();
      debugPrint('✅ PlaceFormCubit: Categorías cargadas: ${categories.length}');

      if (placeId != null) {
        debugPrint('🔄 PlaceFormCubit: Cargando lugar con ID: $placeId');
        final place = await _placeRepository.getPlaceById(placeId);
        debugPrint('✅ PlaceFormCubit: Lugar cargado: ${place.name}');
        secureEmit(PlaceFormLoaded(
          place: place,
          categories: categories,
        ));
      } else {
        debugPrint('ℹ️ PlaceFormCubit: Creando nuevo lugar');
        secureEmit(PlaceFormLoaded(
          place: null,
          categories: categories,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ PlaceFormCubit: Error al cargar datos: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      secureEmit(PlaceFormError(e.toString()));
    }
  }

  Future<void> savePlace(Place place) async {
    secureEmit(PlaceFormSaving());
    try {
      final isNewPlace = place.id.isEmpty;
      final adminAuthCubit = GetIt.instance<AdminAuthCubit>();
      final currentAdmin = adminAuthCubit.currentAdminUser;

      if (currentAdmin == null) {
        throw Exception('No hay un administrador autenticado');
      }

      if (isNewPlace) {
        // Generar un ID temporal para el lugar
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();

        // Actualizar ownedPlaceIds del admin con el ID temporal
        final updatedOwnedPlaceIds = [...currentAdmin.ownedPlaceIds, tempId];
        await adminAuthCubit.updateOwnedPlaces(updatedOwnedPlaceIds);

        // Crear el lugar con el ID temporal
        final placeWithId = place.copyWith(id: tempId);
        final success = await _placeRepository.addPlace(placeWithId);
        if (!success) {
          // Si falla, revertir la actualización de ownedPlaceIds
          await adminAuthCubit.updateOwnedPlaces(currentAdmin.ownedPlaceIds);
          throw Exception('Error al crear el lugar');
        }
      } else {
        final success = await _placeRepository.updatePlace(place);
        if (!success) {
          throw Exception('Error al actualizar el lugar');
        }
      }

      secureEmit(PlaceFormSuccess(isNewPlace: isNewPlace));
      _placeSavedController
          .add(null); // Notify listeners that a place was saved
    } catch (e) {
      secureEmit(PlaceFormError(e.toString()));
    }
  }
}
