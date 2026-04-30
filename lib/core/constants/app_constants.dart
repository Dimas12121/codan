import 'package:flutter/material.dart';
import '../config/environment.dart';

class AppColors {
  static const primary = Color(0xFF7E57C2); // Modern Violet
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF9E9E9E);
  static const error = Color(0xFFE53935);

  // Redesign Colors
  static const primaryLight = Color(0xFFF3E5F5);
  static const accentBlue = Color(0xFFE3F2FD);
  static const accentPink = Color(0xFFFCE4EC);
  static const accentOrange = Color(0xFFFFF3E0);
  static const accentGreen = Color(0xFFE8F5E9);

  static const cardBackground = Color(0xFFFFFFFF);
  static const navInactive = Color(0xFFBDBDBD);

  // Navbar Design Colors
  static const navbarBackground = Color(0xFFE0E0E0);
  static const navbarActive = Color(0xFF2B37D4);
  static const navbarInactive = Color(0xFF5D7D7D);

  // Dashboard Design Colors
  static const searchBarBackground = Color(0xFF8E8EED);
  static const heroBannerTeal = Color(0xFF5B8B8B);
  static const categoryIconBackground = Color(0xFFC7C7FF);
  static const priceBlue = Color(0xFF2B37D4);
}

class AppConstants {
  static String get appName => EnvironmentConfig.appName;

  // Database Configuration (for reference - actual DB is on Laravel backend)
  static const dbName = 'codean_db';
  static const dbUser = 'root';
  static const dbPassword = '';
  static const dbHost = '127.0.0.1';
  static const dbPort = 3306;

  // Base URL untuk Laravel Backend dengan MySQL
  // Menggunakan EnvironmentConfig untuk switching otomatis
  static String get baseUrl => EnvironmentConfig.baseUrl;

  // Endpoint API Laravel dengan MySQL
  static const loginEndpoint = '/login';
  static const loginPhoneEndpoint = '/login-phone';
  static const registerEndpoint = '/register';
  static const registerWithPhoneEndpoint = '/register-with-phone';
  static const logoutEndpoint = '/logout';
  static const userEndpoint = '/user';

  // OTP Endpoints
  static const sendOtpEndpoint = '/send-otp-whatsapp';
  static const verifyOtpEndpoint = '/verify-otp';
  static const checkPhoneEndpoint = '/check-phone';
  static const updatePhoneEndpoint = '/update-phone';
  static const updateProfileEndpoint = '/profile/update';
}
 