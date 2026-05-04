import '../../../../core/constants/app_constants.dart';

class Product {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final String? imageUrl;
  final String category;
  final String condition;
  final String location;
  final int views;
  final int userId;
  final int messages;
  final Seller seller;
  final String type; // sell, rent
  final String? rentalPeriod; // daily, weekly, monthly
  final String status; // active, sold, rented, draft
  final bool isLiked;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.condition,
    required this.location,
    required this.views,
    required this.userId,
    required this.messages,
    required this.seller,
    required this.type,
    this.rentalPeriod,
    this.status = 'active',
    this.isLiked = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['featured_image']?['image_path'] != null 
          ? '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}${json['featured_image']['image_path'].toString().startsWith('/') ? '' : '/'}${json['featured_image']['image_path']}'
          : (json['images'] != null && (json['images'] as List).isNotEmpty 
              ? '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}${(json['images'] as List).first['image_path'].toString().startsWith('/') ? '' : '/'}${(json['images'] as List).first['image_path']}'
              : null),
      category: json['category']?['name'] ?? '',
      condition: json['condition'] ?? 'used',
      location: json['location'] ?? '',
      views: int.tryParse(json['views']?.toString() ?? json['views_count']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      messages: int.tryParse(json['messages_count']?.toString() ?? '0') ?? 0,
      type: json['type'] ?? 'sell',
      rentalPeriod: json['rental_period'],
      status: (json['status'] == 'sold' || json['status'] == 'rented') ? json['status'] : 'active',
      seller: _parseSeller(json['user'] ?? json['seller']),
      isLiked: json['is_wishlist'] ?? false,
    );
  }

  static Seller _parseSeller(dynamic json) {
    if (json == null) return Seller.fromJson({});
    if (json is Map<String, dynamic>) return Seller.fromJson(json);
    if (json is String) return Seller.fromJson({'name': json});
    return Seller.fromJson({});
  }
}

class Seller {
  final int id;
  final String name;
  final String? avatarUrl;
  final String major;
  final String rating;
  final bool isVerified;
  final String? phone;

  Seller({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.major,
    required this.rating,
    this.isVerified = false,
    this.phone,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? 
            json['full_name'] ?? 
            json['nama'] ?? 
            json['nama_lengkap'] ?? 
            json['username'] ?? 
            json['user_name'] ?? 
            json['display_name'] ?? 
            'Penjual',
      avatarUrl: json['avatar'] != null 
          ? (json['avatar'].toString().startsWith('http') ? json['avatar'] : '${AppConstants.baseUrl.replaceAll(RegExp(r'/api$'), '')}/storage/${json['avatar']}')
          : null,
      major: json['major'] ?? 'Mahasiswa',
      rating: json['rating']?.toString() ?? '5.0',
      isVerified: true,
      phone: json['phone']?.toString(),
    );
  }
}
