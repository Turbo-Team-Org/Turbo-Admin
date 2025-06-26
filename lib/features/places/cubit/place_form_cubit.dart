import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:get_it/get_it.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

/// Cubit for managing place form state and operations
class PlaceFormCubit extends Cubit<PlaceFormState> with BaseCubit {
  final PlaceRepository _placeRepository;
  final CategoryRepository _categoryRepository;
  final PlaceCategoryRepositoryInterface _placeCategoryRepository;
  final _placeSavedController = StreamController<void>.broadcast();

  Stream<void> get onPlaceSaved => _placeSavedController.stream;

  PlaceFormCubit({
    required PlaceRepository placeRepository,
    required CategoryRepository categoryRepository,
    required PlaceCategoryRepositoryInterface placeCategoryRepository,
  })  : _placeRepository = placeRepository,
        _categoryRepository = categoryRepository,
        _placeCategoryRepository = placeCategoryRepository,
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

      String placeId = place.id;
      if (isNewPlace) {
        // Generar un ID temporal para el lugar
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        placeId = tempId;

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

      // Insertar en place_categories
      if (place.categoryId.isNotEmpty && placeId.isNotEmpty) {
        await _placeCategoryRepository.upsertPlaceCategory(
          PlaceCategory(
            placeId: placeId,
            categoryId: place.categoryId,
            createdAt: DateTime.now(),
          ),
        );
      }

      secureEmit(PlaceFormSuccess(isNewPlace: isNewPlace));
      _placeSavedController
          .add(null); // Notify listeners that a place was saved
    } catch (e) {
      secureEmit(PlaceFormError(e.toString()));
    }
  }
}
