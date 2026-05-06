import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // Assuming models like Place, Event, Review are here
// You might need to import specific repositories if not covered by a general core.dart
// e.g., import 'package:core/repositories/place_repository.dart';

// --- UI Specific Model (Not from core) ---
class DashboardStats {
  final int totalPlaces;
  final int totalEvents;
  final int totalReviews;
  final double averageRating;

  DashboardStats({
    required this.totalPlaces,
    required this.totalEvents,
    required this.totalReviews,
    required this.averageRating,
  });
}

// --- Dashboard States ---
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  DashboardLoaded(this.stats);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// --- Dashboard Cubit ---
class DashboardCubit extends Cubit<DashboardState> {
  // Assuming repositories are registered with GetIt in turbo_core
  final PlaceRepository _placeRepository;
  final EventRepository _eventRepository;
  final ReviewRepository _reviewRepository;

  DashboardCubit({
    required PlaceRepository placeRepository,
    required EventRepository eventRepository,
    required ReviewRepository reviewRepository,
  })  : _placeRepository = placeRepository,
        _eventRepository = eventRepository,
        _reviewRepository = reviewRepository,
        super(DashboardInitial());

  Future<void> loadDashboardStats() async {
    emit(DashboardLoading());
    try {
      final places = await _placeRepository.getPlaces();
      final events = await _eventRepository.getEvents();
      final reviews = await _reviewRepository.getReviews();

      final stats = DashboardStats(
        totalPlaces: places.length,
        totalEvents: events.length,
        totalReviews: reviews.length,
        averageRating: _calculateAverageRating(reviews),
      );

      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }
    // Assuming Review model has a 'rating' field
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }
}
