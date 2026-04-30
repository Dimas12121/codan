// Model untuk response API Laravel
import 'package:dio/dio.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : null,
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      // ignore: null_check_on_nullable_type_parameter
      'data': data != null ? toJsonT(data!) : null,
      'errors': errors,
    };
  }

  operator [](String other) {}
}

// Model untuk pagination Laravel
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    List<T> Function(dynamic) fromJsonList,
  ) {
    return PaginatedResponse<T>(
      data: fromJsonList(json['data']),
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
    );
  }
}

// Model untuk error response
class ErrorResponse {
  final String message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ErrorResponse({required this.message, this.errors, this.statusCode});

  factory ErrorResponse.fromDioException(DioException e) {
    return ErrorResponse(
      message: e.response?.data['message'] ?? e.message ?? 'An error occurred',
      errors: e.response?.data['errors'] != null
          ? Map<String, dynamic>.from(e.response!.data['errors'])
          : null,
      statusCode: e.response?.statusCode,
    );
  }
}
