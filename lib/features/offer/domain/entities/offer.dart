import '../../../product/domain/entities/product.dart';

class Offer {
  final int id;
  final int userId;
  final int produkId;
  final double offerPrice;
  final String? message;
  final String status;
  final Product? product;
  final DateTime createdAt;

  Offer({
    required this.id,
    required this.userId,
    required this.produkId,
    required this.offerPrice,
    this.message,
    required this.status,
    this.product,
    required this.createdAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      produkId: json['produk_id'] ?? 0,
      offerPrice: double.tryParse(json['offer_price']?.toString() ?? '0') ?? 0,
      message: json['message'],
      status: json['status'] ?? 'pending',
      product: json['produk'] != null ? Product.fromJson(json['produk']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
