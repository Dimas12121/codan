import 'package:dio/dio.dart';
import '../api_client.dart';
import '../models/api_response.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService(this.apiClient);

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await apiClient.dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return ApiResponse<T>.fromJson(response.data, fromJson);
      }

      return ApiResponse<T>(
        success: true,
        message: 'Success',
        data: response.data,
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await apiClient.dio.post(endpoint, data: data);

      if (fromJson != null) {
        return ApiResponse<T>.fromJson(response.data, fromJson);
      }

      return ApiResponse<T>(
        success: true,
        message: 'Success',
        data: response.data,
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await apiClient.dio.put(endpoint, data: data);

      if (fromJson != null) {
        return ApiResponse<T>.fromJson(response.data, fromJson);
      }

      return ApiResponse<T>(
        success: true,
        message: 'Success',
        data: response.data,
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await apiClient.dio.delete(endpoint, data: data);

      if (fromJson != null) {
        return ApiResponse<T>.fromJson(response.data, fromJson);
      }

      return ApiResponse<T>(
        success: true,
        message: 'Success',
        data: response.data,
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await apiClient.dio.post(endpoint, data: formData);

      if (fromJson != null) {
        return ApiResponse<T>.fromJson(response.data, fromJson);
      }

      return ApiResponse<T>(
        success: true,
        message: 'Success',
        data: response.data,
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Get paginated data
  Future<PaginatedResponse<T>> getPaginated<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required List<T> Function(dynamic) fromJsonList,
  }) async {
    try {
      final response = await apiClient.dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return PaginatedResponse<T>.fromJson(response.data, fromJsonList);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
