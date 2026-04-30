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
  final int messages;
  final Seller seller;
  final String type; // sell, rent
  final String? rentalPeriod; // daily, weekly, monthly
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
    required this.messages,
    required this.seller,
    required this.type,
    this.rentalPeriod,
    this.isLiked = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['featured_image']?['image_path'] != null 
          ? '${AppConstants.baseUrl}${json['featured_image']['image_path']}'
          : (json['images'] != null && (json['images'] as List).isNotEmpty 
              ? '${AppConstants.baseUrl}${(json['images'] as List).first['image_path']}'
              : null),
      category: json['category']?['name'] ?? '',
      condition: json['condition'] ?? 'used',
      location: json['location'] ?? '',
      views: json['views_count'] ?? 0,
      messages: 0,
      type: json['type'] ?? 'sell',
      rentalPeriod: json['rental_period'],
      seller: Seller.fromJson(json['user'] ?? {}),
      isLiked: json['is_wishlist'] ?? false,
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String? avatarUrl;
  final String major;
  final String rating;
  final bool isVerified;

  Seller({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.major,
    required this.rating,
    this.isVerified = false,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Penjual',
      avatarUrl: json['avatar'] != null 
          ? (json['avatar'].toString().startsWith('http') ? json['avatar'] : '${AppConstants.baseUrl}/storage/${json['avatar']}')
          : null,
      major: json['major'] ?? 'Teknik Multimedia',
      rating: json['rating']?.toString() ?? '5.0',
      isVerified: true,
    );
  }
}
