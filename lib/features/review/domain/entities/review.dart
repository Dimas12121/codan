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
      id: json['id'] ?? 0,
      reviewerId: json['reviewer_id'] ?? 0,
      revieweeId: json['reviewee_id'] ?? 0,
      produkId: json['produk_id'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      reviewerName: json['reviewer']?['name'] ?? 'User',
      reviewerAvatar: json['reviewer']?['avatar'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
