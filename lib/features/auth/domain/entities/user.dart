import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final bool isPhoneVerified;
  final String? profilePhoto;
  final String? location;
  final String? bio;
  final String? role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isPhoneVerified = false,
    this.profilePhoto,
    this.location,
    this.bio,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['full_name'] ?? json['nama'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['telp'] ?? '',
      isPhoneVerified: json['is_phone_verified'] == 1 ||
          json['is_phone_verified'] == true ||
          json['phone_verified'] == 1 ||
          json['phone_verified'] == true,
      profilePhoto: _parseProfilePhoto(json['profile_photo_url'] ?? json['image'] ?? json['avatar']),
      location: json['location'],
      bio: json['bio'],
      role: json['role'],
    );
  }

  static String? _parseProfilePhoto(dynamic photo) {
    if (photo == null || photo.toString().isEmpty) return null;
    final String photoStr = photo.toString();
    if (photoStr.startsWith('http')) return photoStr;
    return '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}/storage/$photoStr';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'is_phone_verified': isPhoneVerified,
      'profile_photo_url': profilePhoto,
      'location': location,
      'bio': bio,
      'role': role,
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
    location,
    bio,
    role,
  ];
}
