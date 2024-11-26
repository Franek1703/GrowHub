import 'package:bloc/bloc.dart';
import 'package:growhub/features/notification/model/notification_model.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial(notifications: const[]));

  //TODO: Remove this test notification
  void init() {
    testNotification.sort(
      (a, b) => -a.time.compareTo(b.time),
    );
    emit(NotificationLoaded(notifications: testNotification));
  }

  void loadNotification(){
    //TODO: Add function to fetch notifications from server
    emit(NotificationLoaded(notifications: testNotification));
  }


  void markAsResolved(NotificationModel notification) {
    final state = this.state;
    state.notifications.firstWhere((element) => element == notification).isResolved = true;
    //TODO: Add function to send resloved notification to server
    emit(NotificationLoaded(notifications: [...state.notifications]));
  }

  void deleteNotification(NotificationModel notification) {
    final state = this.state;
    emit(NotificationLoaded(notifications: state.notifications.where((element) => element != notification).toList()));
    //TODO: Add function to send delete notification to server
  }

  void refreshNotification(NotificationModel notification) {
    
  }

  List<NotificationModel> testNotification = List.generate(30, (index) {
    bool isResolved = index % 2 == 0;
    DateTime now = DateTime.now();
    DateTime time = now.subtract(Duration(minutes: index * 15));
    DateTime? resolvedTime = isResolved ? now.subtract(Duration(minutes: index * 5)) : null;

    return NotificationModel(
      message: 'Notification #$index: Example message',
      isResolved: isResolved,
      time: time,
      resolvedTime: resolvedTime,
    );
  });
}
