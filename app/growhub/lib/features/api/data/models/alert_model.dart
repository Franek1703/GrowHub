import 'package:intl/intl.dart';

class AlertModel {
  final int id;
  final String message;
  bool isResolved;
  final double value;
  final DateTime time;
  final DateTime? resolvedTime;
  final String sensorName;
  final String deviceName;

  AlertModel({
    required this.message,
    required this.isResolved,
    required this.time,
    this.resolvedTime,
    required this.sensorName,
    required this.deviceName,
    required this.value,
    required this.id,
  });

  factory AlertModel.fromJson(Map<String, dynamic> map) {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return AlertModel(
      id: map['alert_id'] as int,
      message: map['message'] as String,
      isResolved: map['resolved'] as bool,
      value: map['value'] as double,
      time: dateFormat.parse(map['alert_time']),
      resolvedTime: map['resolved_at'] != null ? dateFormat.parse(map['resolved_at']) : null,
      sensorName: map['sensor_name'] as String,
      deviceName: map['device_name'] as String,
    );
  }
  AlertModel copyWith({
    int? id,
    String? message,
    bool? isResolved,
    double? value,
    DateTime? time,
    DateTime? resolvedTime,
    String? sensorName,
    String? deviceName,
  }) {
    return AlertModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isResolved: isResolved ?? this.isResolved,
      value: value ?? this.value,
      time: time ?? this.time,
      resolvedTime: resolvedTime ?? this.resolvedTime,
      sensorName: sensorName ?? this.sensorName,
      deviceName: deviceName ?? this.deviceName,
    );
  }
}
