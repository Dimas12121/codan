import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../../../core/constants/app_constants.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<ApiResponse<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> loginWithPhone({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.loginPhoneEndpoint,
        data: {'phone': phone, 'otp': otp},
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> registerWithPhone({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'buyer',
  }) async {
    try {
      debugPrint('Calling registration endpoint: ${AppConstants.registerWithPhoneEndpoint}');
      final response = await apiClient.dio.post(
        AppConstants.registerWithPhoneEndpoint,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': password,
          'role': role,
        },
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      final response = await apiClient.dio.post(AppConstants.logoutEndpoint);

      return ApiResponse<void>.fromJson(response.data, (data) {});
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  Future<ApiResponse<User>> getUser() async {
    try {
      final response = await apiClient.dio.get(AppConstants.userEndpoint);

      return ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Send OTP via WhatsApp using Fonnte
  Future<ApiResponse<Map<String, dynamic>>> sendOTPviaWhatsApp({
    required String phone,
    required String otp,
    String? email,
    String purpose = 'register',
  }) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.sendOtpEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
          'email': email,
          'purpose': purpose,
          'channel': 'whatsapp',
          'provider': 'fonnte',
          'role': 'buyer',
        },
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Verify OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOTP({
    required String phone,
    required String otp,
    String? email,
    String purpose = 'register',
  }) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.verifyOtpEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
          'email': email,
          'purpose': purpose,
        }..removeWhere((_, v) => v == null),
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Check phone availability
  Future<ApiResponse<Map<String, dynamic>>> checkPhoneAvailability(
    String phone,
  ) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.checkPhoneEndpoint,
        data: {'phone': phone},
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Update phone number
  Future<ApiResponse<Map<String, dynamic>>> updatePhone({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await apiClient.dio.put(
        AppConstants.updatePhoneEndpoint,
        data: {'phone': phone, 'otp': otp},
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  // Refresh token method
  Future<ApiResponse<Map<String, dynamic>>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await apiClient.dio.post(
        '/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
  // Update profile
  Future<ApiResponse<Map<String, dynamic>>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final Map<String, dynamic> formDataMap = Map<String, dynamic>.from(data);
      
      if (data.containsKey('avatar') && data['avatar'] != null) {
        formDataMap['avatar'] = await MultipartFile.fromFile(data['avatar']);
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await apiClient.dio.post(
        AppConstants.updateProfileEndpoint,
        data: formData,
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
