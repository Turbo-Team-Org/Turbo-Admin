import 'package:core/core.dart';

/// Base state class for Place Form feature
abstract class PlaceFormState {}

/// Initial state when the form is first loaded
class PlaceFormInitial extends PlaceFormState {}

/// Loading state while fetching form data
class PlaceFormLoading extends PlaceFormState {}

/// State when form data is loaded and ready for editing
class PlaceFormLoaded extends PlaceFormState {
  final Place? place; // null for create, Place for edit
  final List<Category> categories;

  PlaceFormLoaded({
    this.place,
    required this.categories,
  });
}

/// State while saving the form
class PlaceFormSaving extends PlaceFormState {}

/// State when form is successfully saved
class PlaceFormSuccess extends PlaceFormState {
  final bool isNewPlace;
  PlaceFormSuccess({required this.isNewPlace});
}

/// Error state when something goes wrong
class PlaceFormError extends PlaceFormState {
  final String message;
  PlaceFormError(this.message);
}
