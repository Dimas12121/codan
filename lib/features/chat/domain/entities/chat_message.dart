import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class ChatMessage extends Equatable {
  final int id;
  final int senderId;
  final int receiverId;
  final int produkId;
  final String? message;
  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final bool isRead;
  final String createdAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.produkId,
    this.message,
    this.imagePath,
    this.latitude,
    this.longitude,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String? path = json['image_path'];
    if (path != null && !path.startsWith('http')) {
      path = '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}/storage/$path';
    }
    return ChatMessage(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      senderId: int.tryParse(json['sender_id']?.toString() ?? '') ?? 0,
      receiverId: int.tryParse(json['receiver_id']?.toString() ?? '') ?? 0,
      produkId: int.tryParse(json['produk_id']?.toString() ?? '') ?? 0,
      message: json['message'],
      imagePath: path,
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        produkId,
        message,
        imagePath,
        latitude,
        longitude,
        isRead,
        createdAt,
      ];
}
