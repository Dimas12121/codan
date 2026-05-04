import 'package:equatable/equatable.dart';

class ChatInbox extends Equatable {
  final int id;
  final ChatListing listing;
  final ChatPartner partner;
  final String lastMessage;
  final int unreadCount;
  final String timestamp;

  const ChatInbox({
    required this.id,
    required this.listing,
    required this.partner,
    required this.lastMessage,
    required this.unreadCount,
    required this.timestamp,
  });

  factory ChatInbox.fromJson(Map<String, dynamic> json) {
    return ChatInbox(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      listing: ChatListing.fromJson(json['listing'] ?? {}),
      partner: ChatPartner.fromJson(json['partner'] ?? {}),
      lastMessage: json['last_message'] ?? '',
      unreadCount: int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      timestamp: json['timestamp'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, listing, partner, lastMessage, unreadCount, timestamp];
}

class ChatListing extends Equatable {
  final int id;
  final String title;
  final String image;
  final int? price;

  const ChatListing({
    required this.id,
    required this.title,
    required this.image,
    this.price,
  });

  factory ChatListing.fromJson(Map<String, dynamic> json) {
    return ChatListing(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] != null ? (int.tryParse(json['price'].toString()) ?? 0) : null,
    );
  }

  @override
  List<Object?> get props => [id, title, image, price];
}

class ChatPartner extends Equatable {
  final int id;
  final String name;

  const ChatPartner({
    required this.id,
    required this.name,
  });

  factory ChatPartner.fromJson(Map<String, dynamic> json) {
    return ChatPartner(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? 'User',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Message extends Equatable {
  final int id;
  final int senderId;
  final String? message;
  final String? imagePath;
  final double? latitude;
  final bool isRead;
  final String createdAt;

  const Message({
    required this.id,
    required this.senderId,
    this.message,
    this.imagePath,
    this.latitude,
    required this.isRead,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      senderId: int.tryParse(json['sender_id']?.toString() ?? '') ?? 0,
      message: json['message'],
      imagePath: json['image_path'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, senderId, message, imagePath, latitude, isRead, createdAt];
}
