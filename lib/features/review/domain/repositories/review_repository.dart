import '../entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getUserReviews(int userId);
  Future<Review> createReview({
    required int revieweeId,
    required int produkId,
    required int rating,
    String? comment,
  });
}
