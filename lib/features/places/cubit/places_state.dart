import 'package:core/core.dart';

/// Base state class for Places feature
abstract class PlacesState {}

/// Initial state when the feature is first loaded
class PlacesInitial extends PlacesState {}

/// Loading state while fetching places
class PlacesLoading extends PlacesState {}

/// State when places are successfully loaded
class PlacesLoaded extends PlacesState {
  final List<Place> places;
  final int totalCount;
  final int currentPage;

  PlacesLoaded({
    required this.places,
    required this.totalCount,
    required this.currentPage,
  });
}

/// Error state when something goes wrong
class PlacesError extends PlacesState {
  final String message;
  PlacesError(this.message);
}
