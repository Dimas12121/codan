import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final bool isPhoneVerified;
  final String? profilePhoto;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isPhoneVerified = false,
    this.profilePhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? json['telp'] ?? '',
      isPhoneVerified:
          json['is_phone_verified'] ?? json['phone_verified'] ?? false,
      profilePhoto: json['profile_photo_url'] ?? json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'is_phone_verified': isPhoneVerified,
      'profile_photo_url': profilePhoto,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    isPhoneVerified,
    profilePhoto,
  ];
}
