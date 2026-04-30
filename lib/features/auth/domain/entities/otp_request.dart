import 'package:equatable/equatable.dart';

class OTPRequest extends Equatable {
  final String phone;
  final String otp;
  final String? email;
  final String? purpose; // 'register', 'login', 'reset_password'

  const OTPRequest({
    required this.phone,
    required this.otp,
    this.email,
    this.purpose = 'register',
  });

  factory OTPRequest.fromJson(Map<String, dynamic> json) {
    return OTPRequest(
      phone: json['phone'],
      otp: json['otp'],
      email: json['email'],
      purpose: json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
      if (email != null) 'email': email,
      'purpose': purpose,
    };
  }

  @override
  List<Object?> get props => [phone, otp, email, purpose];
}

class OTPVerification extends Equatable {
  final String phone;
  final String otp;
  final bool isVerified;
  final DateTime? expiresAt;
  final int attempts;

  const OTPVerification({
    required this.phone,
    required this.otp,
    this.isVerified = false,
    this.expiresAt,
    this.attempts = 0,
  });

  factory OTPVerification.fromJson(Map<String, dynamic> json) {
    return OTPVerification(
      phone: json['phone'],
      otp: json['otp'],
      isVerified: json['is_verified'] ?? false,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      attempts: json['attempts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
      'is_verified': isVerified,
      'expires_at': expiresAt?.toIso8601String(),
      'attempts': attempts,
    };
  }

  bool get isExpired {
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get canResend {
    // Allow resend after 60 seconds
    if (expiresAt == null) return true;
    final timeSinceLast = DateTime.now().difference(expiresAt!);
    return timeSinceLast.inSeconds.abs() > 60;
  }

  @override
  List<Object?> get props => [phone, otp, isVerified, expiresAt, attempts];
}
