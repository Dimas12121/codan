import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../domain/entities/offer.dart';

abstract class OfferRemoteDataSource {
  Future<List<Offer>> getOffers(String type);
  Future<Offer> createOffer({
    required int produkId,
    required double offerPrice,
    String? message,
  });
  Future<Offer> updateOfferStatus(int id, String status);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final ApiClient apiClient;

  OfferRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<Offer>> getOffers(String type) async {
    try {
      final response = await apiClient.dio.get('/offers', queryParameters: {'type': type});
      final List<dynamic> data = response.data['data']['data'] ?? response.data['data'];
      return data.map((json) => Offer.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Offer> createOffer({
    required int produkId,
    required double offerPrice,
    String? message,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/offers',
        data: {
          'produk_id': produkId,
          'offer_price': offerPrice,
          'message': message,
        },
      );
      return Offer.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Offer> updateOfferStatus(int id, String status) async {
    try {
      final response = await apiClient.dio.patch(
        '/offers/$id/status',
        data: {'status': status},
      );
      return Offer.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
