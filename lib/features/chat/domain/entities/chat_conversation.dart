import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class ChatPartner extends Equatable {
  final int id;
  final String name;
  final String? avatar;

  const ChatPartner({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory ChatPartner.fromJson(Map<String, dynamic> json) {
    String? avatarPath = json['avatar'];
    if (avatarPath != null && !avatarPath.startsWith('http')) {
      avatarPath = '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}/storage/$avatarPath';
    }
    return ChatPartner(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? json['full_name'] ?? json['nama'] ?? 'Pengguna',
      avatar: avatarPath,
    );
  }

  @override
  List<Object?> get props => [id, name, avatar];
}

class ChatProduk extends Equatable {
  final int id;
  final String title;
  final String? image;
  final num? price;

  const ChatProduk({
    required this.id,
    required this.title,
    this.image,
    this.price,
  });

  factory ChatProduk.fromJson(Map<String, dynamic> json) {
    String? imagePath = json['image'] ?? json['featured_image']?['image_path'];
    if (imagePath != null && !imagePath.startsWith('http')) {
      imagePath = '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}/storage/$imagePath';
    }
    return ChatProduk(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title'] ?? '',
      image: imagePath,
      price: json['price'] != null ? (num.tryParse(json['price'].toString()) ?? 0) : null,
    );
  }

  @override
  List<Object?> get props => [id, title, image, price];
}

class ChatConversation extends Equatable {
  final int id;
  final ChatProduk produk;
  final ChatPartner partner;
  final String lastMessage;
  final int unreadCount;
  final String createdAt;
  final String timestamp;

  const ChatConversation({
    required this.id,
    required this.produk,
    required this.partner,
    required this.lastMessage,
    required this.unreadCount,
    required this.createdAt,
    required this.timestamp,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      produk: ChatProduk.fromJson(json['produk'] ?? {}),
      partner: ChatPartner.fromJson(json['partner'] ?? {}),
      lastMessage: json['last_message'] ?? '',
      unreadCount: int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        produk,
        partner,
        lastMessage,
        unreadCount,
        createdAt,
        timestamp,
      ];
}
