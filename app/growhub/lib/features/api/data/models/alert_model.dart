// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    return AlertModel(
      id: map['alert_id'] as int,
      message: map['message'] as String,
      isResolved: map['resolved'] as bool,
      value: map['value'] as double,
      time: DateTime.fromMillisecondsSinceEpoch(map['alert_time'] as int),
      resolvedTime: map['resolved_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['resolvedTime'] as int) : null,
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
