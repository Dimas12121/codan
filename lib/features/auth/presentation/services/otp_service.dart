import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPService {
  static const String _otpStorageKey = 'otp_data';
  static const String _otpAttemptsKey = 'otp_attempts';
  static const String _otpResendTimeKey = 'otp_resend_time';

  // Generate random 6-digit OTP
  static String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Generate OTP with expiration time (default 5 minutes)
  static Map<String, dynamic> generateOTPWithExpiry({
    Duration expiresIn = const Duration(minutes: 5),
  }) {
    final otp = generateOTP();
    final expiresAt = DateTime.now().add(expiresIn);

    return {
      'otp': otp,
      'expires_at': expiresAt.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'attempts': 0,
      'is_verified': false,
    };
  }

  // Save OTP data to local storage (JSON)
  static Future<void> saveOTPData(
    String phone,
    Map<String, dynamic> otpData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final otpMap = {'phone': phone, ...otpData};
    await prefs.setString(_otpStorageKey, jsonEncode(otpMap));
  }

  // Get OTP data from local storage
  static Future<Map<String, dynamic>?> getOTPData() async {
    final prefs = await SharedPreferences.getInstance();
    final otpData = prefs.getString(_otpStorageKey);

    if (otpData == null) return null;

    try {
      return Map<String, dynamic>.from(jsonDecode(otpData));
    } catch (e) {
      return null;
    }
  }

  // Clear OTP data
  static Future<void> clearOTPData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_otpStorageKey);
    await prefs.remove(_otpAttemptsKey);
    await prefs.remove(_otpResendTimeKey);
  }

  // Check if OTP is expired
  static bool isOTPExpired(Map<String, dynamic> otpData) {
    final expiresAtStr = otpData['expires_at'];
    if (expiresAtStr == null) return true;

    try {
      final expiresAt = DateTime.parse(expiresAtStr);
      return DateTime.now().isAfter(expiresAt);
    } catch (e) {
      return true;
    }
  }

  // Increment OTP attempts
  static Future<void> incrementOTPAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getInt(_otpAttemptsKey) ?? 0;
    await prefs.setInt(_otpAttemptsKey, attempts + 1);
  }

  // Get OTP attempts
  static Future<int> getOTPAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_otpAttemptsKey) ?? 0;
  }

  // Check if max attempts reached (default 5)
  static Future<bool> isMaxAttemptsReached({int maxAttempts = 5}) async {
    final attempts = await getOTPAttempts();
    return attempts >= maxAttempts;
  }

  // Save resend time
  static Future<void> saveResendTime() async {
    final prefs = await SharedPreferences.getInstance();
    final resendTime = DateTime.now().add(const Duration(seconds: 60));
    await prefs.setString(_otpResendTimeKey, resendTime.toIso8601String());
  }

  // Check if can resend OTP
  static Future<bool> canResendOTP() async {
    final prefs = await SharedPreferences.getInstance();
    final resendTimeStr = prefs.getString(_otpResendTimeKey);

    if (resendTimeStr == null) return true;

    try {
      final resendTime = DateTime.parse(resendTimeStr);
      return DateTime.now().isAfter(resendTime);
    } catch (e) {
      return true;
    }
  }

  // Get remaining seconds for resend
  static Future<int> getResendRemainingSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    final resendTimeStr = prefs.getString(_otpResendTimeKey);

    if (resendTimeStr == null) return 0;

    try {
      final resendTime = DateTime.parse(resendTimeStr);
      final now = DateTime.now();

      if (now.isAfter(resendTime)) return 0;

      final difference = resendTime.difference(now);
      return difference.inSeconds;
    } catch (e) {
      return 0;
    }
  }

  // Format phone number for display
  static String formatPhoneNumber(String phone) {
    if (phone.isEmpty) return phone;

    // Remove non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Format Indonesian phone number
    if (digits.startsWith('0')) {
      return '+62${digits.substring(1)}';
    } else if (digits.startsWith('62')) {
      return '+$digits';
    } else {
      return '+62$digits';
    }
  }

  // Validate phone number format
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;

    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Indonesian phone number validation
    if (digits.startsWith('0')) {
      return digits.length >= 10 && digits.length <= 13;
    } else if (digits.startsWith('62')) {
      return digits.length >= 11 && digits.length <= 14;
    }

    return false;
  }

  // Mask phone number for display
  static String maskPhoneNumber(String phone) {
    if (phone.length <= 4) return phone;

    final formattedPhone = formatPhoneNumber(phone);
    final length = formattedPhone.length;

    if (length <= 8) {
      return '${formattedPhone.substring(0, 3)}***${formattedPhone.substring(length - 2)}';
    } else {
      return '${formattedPhone.substring(0, 4)}****${formattedPhone.substring(length - 3)}';
    }
  }

  // Format OTP display (e.g., 1-2-3-4-5-6)
  static String formatOTPDisplay(String otp) {
    if (otp.length != 6) return otp;

    final chars = otp.split('');
    return '${chars[0]} ${chars[1]} ${chars[2]} ${chars[3]} ${chars[4]} ${chars[5]}';
  }

  // Show OTP timer widget
  static Widget buildOTPTimer(Future<int> remainingSecondsFuture) {
    return FutureBuilder<int>(
      future: remainingSecondsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final seconds = snapshot.data!;

          if (seconds > 0) {
            return Text(
              'Dapat mengirim ulang dalam $seconds detik',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            );
          } else {
            return const Text(
              'Kirim ulang OTP',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  // Validate OTP input
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP tidak boleh kosong';
    }

    if (value.length != 6) {
      return 'OTP harus 6 digit';
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'OTP harus berupa angka';
    }

    return null;
  }

  // Get OTP expiration time in minutes
  static int getOTPExpirationMinutes(Map<String, dynamic> otpData) {
    final expiresAtStr = otpData['expires_at'];
    if (expiresAtStr == null) return 0;

    try {
      final expiresAt = DateTime.parse(expiresAtStr);
      final now = DateTime.now();

      if (now.isAfter(expiresAt)) return 0;

      final difference = expiresAt.difference(now);
      return difference.inMinutes;
    } catch (e) {
      return 0;
    }
  }
}
