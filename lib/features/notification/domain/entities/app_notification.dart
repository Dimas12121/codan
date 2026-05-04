class AppNotification {
  final int id;
  final String title;
  final String message;
  final String type;
  final DateTime? readAt;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.readAt,
    required this.createdAt,
    required this.data,
  });

  bool get isRead => readAt != null;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['data']?['title'] ?? 'Notification',
      message: json['data']?['message'] ?? '',
      type: json['type'] ?? 'general',
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      data: json['data'] ?? {},
    );
  }
}
