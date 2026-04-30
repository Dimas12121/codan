import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../domain/entities/app_notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotification>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await apiClient.dio.get('/notifications');
      final List<dynamic> data = response.data['data']['data'] ?? response.data['data'];
      return data.map((json) => AppNotification.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await apiClient.dio.get('/notifications/unread-count');
      return response.data['unread_count'] ?? 0;
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await apiClient.dio.patch('/notifications/$id/read');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await apiClient.dio.post('/notifications/read-all');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> deleteNotification(int id) async {
    try {
      await apiClient.dio.delete('/notifications/$id');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
