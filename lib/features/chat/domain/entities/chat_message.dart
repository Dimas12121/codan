import 'package:equatable/equatable.dart';

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
    return ChatMessage(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      produkId: json['produk_id'] ?? 0,
      message: json['message'],
      imagePath: json['image_path'],
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
