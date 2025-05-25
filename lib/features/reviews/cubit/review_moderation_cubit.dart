import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Review model, ReviewRepository, ReviewService

// --- ReviewModeration States ---
abstract class ReviewModerationState {}

class ReviewModerationInitial extends ReviewModerationState {}

class ReviewModerationLoading extends ReviewModerationState {}

// State when a single review is loaded for moderation
class ReviewModerationLoaded extends ReviewModerationState {
  final Review review;
  ReviewModerationLoaded(this.review);
}

// State after a moderation action (approve, reject) is successful
class ReviewModerationActionSuccess extends ReviewModerationState {
  final String message;
  ReviewModerationActionSuccess(this.message);
}

class ReviewModerationError extends ReviewModerationState {
  final String message;
  ReviewModerationError(this.message);
}

// --- ReviewModeration Cubit ---
class ReviewModerationCubit extends Cubit<ReviewModerationState> {
  final ReviewRepository _reviewRepository;
  final ReviewService _reviewService;

  ReviewModerationCubit({
    ReviewRepository? reviewRepository,
    ReviewService? reviewService,
  }) : _reviewRepository = reviewRepository ?? GetIt.instance<ReviewRepository>(),
       _reviewService = reviewService ?? GetIt.instance<ReviewService>(),
       super(ReviewModerationInitial());

  Future<void> loadReviewForModeration(String reviewId) async {
    emit(ReviewModerationLoading());
    try {
      final review = await _reviewRepository.getReviewById(reviewId);
      if (review != null) {
        emit(ReviewModerationLoaded(review));
      } else {
        emit(ReviewModerationError('Reseña no encontrada.'));
      }
    } catch (e) {
      emit(ReviewModerationError(e.toString()));
    }
  }

  Future<void> approveReview(String reviewId) async {
    emit(ReviewModerationLoading()); // Or a specific "ApprovingReview" state
    try {
      // Assuming Review model has a 'status' field and ReviewStatus enum exists in core
      await _reviewService.updateReviewStatus(reviewId, ReviewStatus.approved);
      emit(ReviewModerationActionSuccess('Reseña aprobada exitosamente.'));
      // Optionally, can emit the updated review:
      // final updatedReview = await _reviewRepository.getReviewById(reviewId);
      // if (updatedReview != null) emit(ReviewModerationLoaded(updatedReview));
    } catch (e) {
      emit(ReviewModerationError('Error al aprobar reseña: ${e.toString()}'));
    }
  }

  Future<void> rejectReview(String reviewId, {String? reason}) async {
    emit(ReviewModerationLoading()); // Or a specific "RejectingReview" state
    try {
      // Assuming ReviewService can handle rejection, possibly with a reason
      await _reviewService.updateReviewStatus(reviewId, ReviewStatus.rejected, reason: reason);
      emit(ReviewModerationActionSuccess('Reseña rechazada exitosamente.'));
    } catch (e) {
      emit(ReviewModerationError('Error al rechazar reseña: ${e.toString()}'));
    }
  }
  
  Future<void> deleteReview(String reviewId) async {
    emit(ReviewModerationLoading());
    try {
      await _reviewService.deleteReview(reviewId);
      emit(ReviewModerationActionSuccess('Reseña eliminada exitosamente.'));
    } catch (e) {
      emit(ReviewModerationError('Error al eliminar reseña: ${e.toString()}'));
    }
  }
}
