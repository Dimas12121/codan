import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts({String? category, String? search, String? type});
  Future<Product> getProductDetail(String identifier);
  Future<List<Product>> getMyProducts();
  Future<Product> createProduct(Map<String, dynamic> data);
  Future<Product> updateProduct(int id, Map<String, dynamic> data);
  Future<void> deleteProduct(int id);
  Future<List<Map<String, dynamic>>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<Product>> getProducts({String? category, String? search, String? type}) async {
    try {
      final response = await apiClient.dio.get(
        '/produks',
        queryParameters: {
          'category': category,
          'search': search,
          'type': type,
        }..removeWhere((_, v) => v == null),
      );

      if (response.data is! Map) {
        throw 'Invalid response format: Expected JSON Map but got ${response.data.runtimeType}';
      }

      final dynamic responseData = response.data['data'];
      final List<dynamic> data;
      
      if (responseData is Map && responseData.containsKey('data')) {
        data = responseData['data'] ?? [];
      } else if (responseData is List) {
        data = responseData;
      } else {
        data = [];
      }
      
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Product> getProductDetail(String identifier) async {
    try {
      final response = await apiClient.dio.get('/produks/$identifier');
      if (response.data is! Map || response.data['data'] == null) {
        throw 'Product detail not found or invalid response';
      }
      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<List<Product>> getMyProducts() async {
    try {
      final response = await apiClient.dio.get('/produks/my');
      if (response.data is! Map) {
        throw 'Invalid response format';
      }

      final dynamic responseData = response.data['data'];
      final List<dynamic> data;
      
      if (responseData is Map && responseData.containsKey('data')) {
        data = responseData['data'] ?? [];
      } else if (responseData is List) {
        data = responseData;
      } else {
        data = [];
      }
      
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      
      if (data.containsKey('images')) {
        final List<String> imagePaths = List<String>.from(data['images']);
        final List<MultipartFile> files = [];
        for (final path in imagePaths) {
          files.add(await MultipartFile.fromFile(path));
        }
        map['images[]'] = files; // Laravel usually expects array with [] suffix
        map.remove('images');
      }

      final formData = FormData.fromMap(map);
      final response = await apiClient.dio.post('/produks', data: formData);
      if (response.data is! Map || response.data['data'] == null) {
        throw 'Failed to create product: Invalid response';
      }
      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Product> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      map['_method'] = 'PATCH'; // For multipart/form-data support in Laravel update

      if (data.containsKey('images')) {
        final List<String> imagePaths = List<String>.from(data['images']);
        final List<MultipartFile> files = [];
        for (final path in imagePaths) {
          files.add(await MultipartFile.fromFile(path));
        }
        map['images[]'] = files;
        map.remove('images');
      }

      final formData = FormData.fromMap(map);
      final response = await apiClient.dio.post('/produks/$id', data: formData);
      if (response.data is! Map || response.data['data'] == null) {
        throw 'Failed to update product: Invalid response';
      }
      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await apiClient.dio.delete('/produks/$id');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/categories');
      if (response.data is! Map || response.data['data'] == null) {
        return [];
      }
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Map<String, dynamic>.from(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
