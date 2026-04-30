// Auth Storage untuk secure storage menggunakan flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _authExpiryKey = 'auth_expiry';

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Save user data
  static Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userDataKey, value: userData);
  }

  // Get user data
  static Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  // Save auth expiry
  static Future<void> saveAuthExpiry(String expiry) async {
    await _storage.write(key: _authExpiryKey, value: expiry);
  }

  // Get auth expiry
  static Future<String?> getAuthExpiry() async {
    return await _storage.read(key: _authExpiryKey);
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    final expiry = await getAuthExpiry();
    if (expiry == null) return true;

    try {
      final expiryTime = DateTime.parse(expiry);
      return DateTime.now().isAfter(expiryTime);
    } catch (e) {
      return true;
    }
  }

  // Clear all auth data
  static Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userDataKey);
    await _storage.delete(key: _authExpiryKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null) return false;

    final isExpired = await isTokenExpired();
    return !isExpired;
  }

  // Get all stored data (for debugging)
  static Future<Map<String, String?>> getAllData() async {
    return {
      'access_token': await getAccessToken(),
      'refresh_token': await getRefreshToken(),
      'user_data': await getUserData(),
      'auth_expiry': await getAuthExpiry(),
    };
  }

  // Save auth session
  static Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required String userData,
    required Duration expiresIn,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveUserData(userData);

    final expiryTime = DateTime.now().add(expiresIn);
    await saveAuthExpiry(expiryTime.toIso8601String());
  }

  // Get auth session
  static Future<Map<String, dynamic>?> getAuthSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final userData = await getUserData();
    final authExpiry = await getAuthExpiry();

    if (accessToken == null) return null;

    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_data': userData,
      'auth_expiry': authExpiry,
    };
  }
}
