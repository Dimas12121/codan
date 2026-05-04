import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
    on<DeleteNotificationEvent>(_onDelete);
  }

  Future<void> _onLoadNotifications(LoadNotifications event, Emitter<NotificationState> emit) async {
    // Only show loading if we don't have data yet
    if (state is! NotificationLoaded) {
      emit(NotificationLoading());
    }
    try {
      final notifications = await repository.getNotifications();
      final unreadCount = await repository.getUnreadCount();
      emit(NotificationLoaded(notifications: notifications, unreadCount: unreadCount));
    } catch (e) {
      // If we already have data, don't show error state, just keep current data
      if (state is! NotificationLoaded) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onMarkAsRead(MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    try {
      await repository.markAsRead(event.id);
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkAllAsRead(MarkAllNotificationsAsRead event, Emitter<NotificationState> emit) async {
    try {
      await repository.markAllAsRead();
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.deleteNotification(event.id);
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
