import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../../product/domain/entities/product.dart';

abstract class WishlistRemoteDataSource {
  Future<List<Product>> getWishlist();
  Future<bool> toggleWishlist(int produkId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<Product>> getWishlist() async {
    try {
      final response = await apiClient.dio.get('/wishlists');
      final List<dynamic> data = response.data['data']['data'] ?? response.data['data'];
      
      // Wishlist items usually contain a 'produk' object
      return data.map((item) => Product.fromJson(item['produk'])).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<bool> toggleWishlist(int produkId) async {
    try {
      final response = await apiClient.dio.post(
        '/wishlists/toggle',
        data: {'produk_id': produkId},
      );
      
      return response.data['status'] == 'added';
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
