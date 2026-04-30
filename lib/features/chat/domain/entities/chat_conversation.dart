import 'package:equatable/equatable.dart';

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
    return ChatPartner(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'],
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
    return ChatProduk(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      price: json['price'],
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
      id: json['id'] ?? 0,
      produk: ChatProduk.fromJson(json['produk'] ?? {}),
      partner: ChatPartner.fromJson(json['partner'] ?? {}),
      lastMessage: json['last_message'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
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
