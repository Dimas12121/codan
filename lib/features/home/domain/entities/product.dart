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
          ? 'http://127.0.0.1:8000' + json['featured_image']['image_path'] // adjust base url accordingly
          : null,
      category: json['category']?['name'] ?? '',
      condition: json['condition'] ?? 'used',
      location: json['location'] ?? '',
      views: json['views_count'] ?? 0,
      messages: 0, // usually requires separate logic or count field
      seller: Seller.fromJson(json['user'] ?? {}),
    );
  }

  get type => null;
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
      name: json['name'] ?? '',
      avatarUrl: json['avatar'] != null ? 'http://127.0.0.1:8000/storage/' + json['avatar'] : null,
      major: json['major'] ?? '-',
      rating: '5.0', // placeholder if not from backend
      isVerified: true, // placeholder
    );
  }
}
