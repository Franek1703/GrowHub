part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {
  final List<NotificationModel> notifications;

  NotificationState({required this.notifications});
}

final class NotificationInitial extends NotificationState {
  NotificationInitial({required super.notifications});
}

final class NotificationLoading extends NotificationState {
  NotificationLoading({required super.notifications});
}

final class NotificationLoaded extends NotificationState {
  NotificationLoaded({required super.notifications});
}
