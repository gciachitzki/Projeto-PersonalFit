import '../entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews();
  Future<Review> createReview(Review review);
  Future<void> updateReview(String reviewId, {double? rating, String? comment, List<String>? photos});
  Future<void> deleteReview(String reviewId);
  Future<List<Review>> getPersonalReviews(String personalId);
  Future<List<Review>> getUserReviews(String userId);
  Future<void> updatePersonalRating(String personalId, double newRating);
} 