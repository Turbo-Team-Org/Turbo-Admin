import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Review model, ReviewRepository, ReviewService

// --- Reviews States ---
abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final int totalCount;
  final int currentPage;
  // Add any other relevant data for the UI, e.g., average rating if calculated here

  ReviewsLoaded({
    required this.reviews,
    required this.totalCount,
    required this.currentPage,
  });
}

class ReviewsError extends ReviewsState {
  final String message;
  ReviewsError(this.message);
}

// --- Reviews Cubit ---
class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewRepository _reviewRepository;
  // For actions like delete or status change

  ReviewsCubit({
    required ReviewRepository reviewRepository,
  })  : _reviewRepository = reviewRepository,
        super(ReviewsInitial());

  Future<void> loadReviews({
    int page = 1,
    String? placeId,
    String? userId,
    ReviewStatus?
        status, // Assuming Review model has a status (e.g., pending, approved, rejected)
  }) async {
    emit(ReviewsLoading());
    try {
      // Example: Repository might have a versatile getReviews method
      // Or specific methods like getReviewsByPlaceId, getReviewsByUserId, getReviewsByStatus
      final PagedResult<Review>
          pagedResult; // Assuming repository returns a PagedResult

      // This is a placeholder for actual filtering.
      // You'd likely pass filter parameters to the repository.
      // For simplicity, showing a generic load here.
      if (placeId != null) {
        pagedResult = await _reviewRepository.getReviewsByPlaceId(
          placeId,
          page: page,
          limit: 20,
        );
      } else if (userId != null) {
        pagedResult = await _reviewRepository.getReviewsByUserId(
          userId,
          page: page,
          limit: 20,
        );
      } else if (status != null) {
        pagedResult = await _reviewRepository.getReviewsByStatus(
          status,
          page: page,
          limit: 20,
        );
      } else {
        pagedResult =
            await _reviewRepository.getAllReviews(page: page, limit: 20);
      }

      emit(
        ReviewsLoaded(
          reviews: pagedResult.items,
          totalCount: pagedResult.totalCount,
          currentPage: pagedResult.currentPage,
        ),
      );
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _reviewRepository.deleteReview(reviewId);
      // Refresh the list. Consider current filters if any.
      // For simplicity, just calling loadReviews() which might reset to default filters.
      // A more sophisticated approach would re-load with the last used filters.
      await loadReviews();
    } catch (e) {
      emit(ReviewsError('Error al eliminar reseña: ${e.toString()}'));
      // Optionally re-emit current data if state was ReviewsLoaded
    }
  }

  Future<void> updateReviewStatus(
    String reviewId,
    ReviewStatus newStatus,
  ) async {
    try {
      // Assuming ReviewService has a method to update status
      await _reviewRepository.updateReviewStatus(reviewId, newStatus);
      // Refresh reviews to reflect the change
      await loadReviews(); // Or update the specific review in the list locally
    } catch (e) {
      emit(
        ReviewsError(
          'Error al actualizar estado de la reseña: ${e.toString()}',
        ),
      );
    }
  }
}
