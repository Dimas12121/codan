// Model untuk response API Laravel
import 'package:dio/dio.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? rawJson;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.rawJson,
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
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      // ignore: null_check_on_nullable_type_parameter
      'data': data != null ? toJsonT(data!) : null,
      'errors': errors,
      'rawJson': rawJson,
    };
  }

  dynamic operator [](String key) => rawJson?[key];
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
    String message = 'An error occurred';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Unable to connect to server. Please check your network.';
    } else if (e.type == DioExceptionType.cancel) {
      message = 'Request was cancelled.';
    } else if (e.response != null) {
      // Handle Laravel validation errors (422)
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors is Map) {
          final errorMessages = errors.values
              .map((list) => list is List ? list.join(', ') : list.toString())
              .join('\n');
          if (errorMessages.isNotEmpty) {
            message = errorMessages;
          } else {
            message = e.response?.data['message'] ?? 'Validation error';
          }
        } else {
          message = e.response?.data['message'] ?? 'Validation error';
        }
      } else {
        message = e.response?.data['message'] ??
            e.response?.statusMessage ??
            'Server error (${e.response?.statusCode})';
      }
    } else {
      message = e.message ?? 'An unexpected error occurred';
    }

    return ErrorResponse(
      message: message,
      errors: e.response?.data['errors'] != null
          ? Map<String, dynamic>.from(e.response!.data['errors'])
          : null,
      statusCode: e.response?.statusCode,
    );
  }

  @override
  String toString() => message;
}
