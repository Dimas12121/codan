import 'package:codan/features/notification/domain/entities/app_notification.dart';
import 'package:codan/features/notification/domain/repositories/notification_repository.dart';
import 'package:codan/features/notification/data/datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AppNotification>> getNotifications() async {
    return await remoteDataSource.getNotifications();
  }

  @override
  Future<int> getUnreadCount() async {
    return await remoteDataSource.getUnreadCount();
  }

  @override
  Future<void> markAsRead(int id) async {
    return await remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    return await remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(int id) async {
    return await remoteDataSource.deleteNotification(id);
  }
}
