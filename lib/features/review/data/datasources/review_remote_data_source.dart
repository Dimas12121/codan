import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../domain/entities/review.dart';

abstract class ReviewRemoteDataSource {
  Future<List<Review>> getUserReviews(int userId);
  Future<Review> createReview({
    required int revieweeId,
    required int produkId,
    required int rating,
    String? comment,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<Review>> getUserReviews(int userId) async {
    try {
      final response = await apiClient.dio.get('/reviews/user/$userId');
      final List<dynamic> data = response.data['data']['data'] ?? response.data['data'];
      return data.map((json) => Review.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Review> createReview({
    required int revieweeId,
    required int produkId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/reviews',
        data: {
          'reviewee_id': revieweeId,
          'produk_id': produkId,
          'rating': rating,
          'comment': comment,
        },
      );
      return Review.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
