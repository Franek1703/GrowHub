class NotificationModel {
  final String message;
  // final Sensor sensor; //Todo: uncomment this after merge with Kuba's backend
  bool isResolved;
  final DateTime time;
  final DateTime? resolvedTime;

  NotificationModel({
    required this.message,
    // required this.sensor,
    required this.isResolved,
    required this.time,
    this.resolvedTime,
  });
}
