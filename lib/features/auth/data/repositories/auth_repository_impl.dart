import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/api/models/api_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    final apiResponse = await remoteDataSource.login(email, password);

    if (apiResponse.success) {
      final token = apiResponse['access_token'];
      if (token != null) {
        await localDataSource.saveToken(token);
      }
      
      final userData = apiResponse.data ?? apiResponse['user'];
      if (userData == null) throw 'User data not found in response';
      
      return User.fromJson(userData);
    } else {
      throw apiResponse.message;
    }
  }

  @override
  Future<User> register(String name, String email, String password, {String role = 'buyer'}) async {
    // For backward compatibility, use registerWithPhone with empty phone
    return await registerWithPhone(
      name: name,
      email: email,
      phone: '',
      password: password,
      role: role,
    );
  }

  @override
  Future<User> registerWithPhone({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'buyer',
  }) async {
    final apiResponse = await remoteDataSource.registerWithPhone(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );

    if (apiResponse.success) {
      final token = apiResponse['access_token'];
      if (token != null) {
        await localDataSource.saveToken(token);
      }

      final userData = apiResponse.data ?? apiResponse['user'];
      if (userData == null) throw 'User data not found in response';

      return User.fromJson(userData);
    } else {
      throw apiResponse.message;
    }
  }

  @override
  Future<void> logout() async {
    final apiResponse = await remoteDataSource.logout();

    if (apiResponse.success) {
      await localDataSource.clearToken();
    } else {
      // Even if logout API fails, clear local token
      await localDataSource.clearToken();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await localDataSource.getToken();
    if (token == null) return null;

    try {
      final apiResponse = await remoteDataSource.getUser();

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        // If API returns unsuccessful response, clear token
        await localDataSource.clearToken();
        return null;
      }
    } catch (_) {
      // If any error occurs, clear token for security
      await localDataSource.clearToken();
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null;
  }

  @override
  Future<User> loginWithPhone({
    required String phone,
    required String otp,
  }) async {
    final apiResponse = await remoteDataSource.loginWithPhone(
      phone: phone,
      otp: otp,
    );

    if (apiResponse.success) {
      final token = apiResponse['access_token'];
      if (token != null) {
        await localDataSource.saveToken(token);
      }

      final userData = apiResponse.data ?? apiResponse['user'];
      if (userData == null) throw 'User data not found in response';

      return User.fromJson(userData);
    } else {
      throw apiResponse.message;
    }
  }

  // OTP Methods
  @override
  Future<ApiResponse<Map<String, dynamic>>> sendOTPviaWhatsApp({
    required String phone,
    required String otp,
    String? email,
    String purpose = 'register',
  }) async {
    return await remoteDataSource.sendOTPviaWhatsApp(
      phone: phone,
      otp: otp,
      email: email,
      purpose: purpose,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> verifyOTP({
    required String phone,
    required String otp,
    String? email,
    String purpose = 'register',
  }) async {
    return await remoteDataSource.verifyOTP(
      phone: phone,
      otp: otp,
      email: email,
      purpose: purpose,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> checkPhoneAvailability(
    String phone,
  ) async {
    return await remoteDataSource.checkPhoneAvailability(phone);
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> updatePhone({
    required String phone,
    required String otp,
  }) async {
    return await remoteDataSource.updatePhone(phone: phone, otp: otp);
  }
}
