class Review {
  final int id;
  final int reviewerId;
  final int revieweeId;
  final int produkId;
  final int rating;
  final String? comment;
  final String reviewerName;
  final String? reviewerAvatar;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.produkId,
    required this.rating,
    this.comment,
    required this.reviewerName,
    this.reviewerAvatar,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      reviewerId: int.tryParse(json['reviewer_id']?.toString() ?? '') ?? 0,
      revieweeId: int.tryParse(json['reviewee_id']?.toString() ?? '') ?? 0,
      produkId: int.tryParse(json['produk_id']?.toString() ?? '') ?? 0,
      rating: int.tryParse(json['rating']?.toString() ?? '') ?? 0,
      comment: json['comment'],
      reviewerName: json['reviewer']?['name'] ?? 'User',
      reviewerAvatar: json['reviewer']?['avatar'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
