import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Review>> getUserReviews(int userId) =>
      remoteDataSource.getUserReviews(userId);

  @override
  Future<Review> createReview({
    required int revieweeId,
    required int produkId,
    required int rating,
    String? comment,
  }) =>
      remoteDataSource.createReview(
        revieweeId: revieweeId,
        produkId: produkId,
        rating: rating,
        comment: comment,
      );
}
