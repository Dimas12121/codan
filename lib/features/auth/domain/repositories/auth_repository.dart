import 'package:codan/core/api/models/api_response.dart';
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password, String phone, {String role = 'buyer'});
  Future<User> registerWithPhone({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'buyer',
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<User> loginWithPhone({
    required String phone,
    required String otp,
  });

  // OTP Methods
  Future<ApiResponse<Map<String, dynamic>>> sendOTPviaWhatsApp({
    required String phone,
    required String otp,
    String? email,
    String purpose,
  });

  Future<ApiResponse<Map<String, dynamic>>> verifyOTP({
    required String phone,
    required String otp,
    String? email,
    String purpose,
  });

  Future<ApiResponse<Map<String, dynamic>>> checkPhoneAvailability(
    String phone,
  );
  Future<ApiResponse<Map<String, dynamic>>> updatePhone({
    required String phone,
    required String otp,
  });
  Future<User> updateProfile(Map<String, dynamic> data);
}
