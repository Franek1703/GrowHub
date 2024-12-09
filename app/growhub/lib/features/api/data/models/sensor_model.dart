import 'package:growhub/features/api/data/models/sensor_reading_model.dart';

class SensorModel {
  final int id;
  final String name;
  final String unit;
  final SensorReadingModel? lastSensorReading;

  List<SensorReadingModel> readings;

  SensorModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.lastSensorReading,
    this.readings = const [],
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['sensor_id'],
      name: json['sensor_type'],
      unit: json["unit"],
      lastSensorReading:
          json['last_reading'] != null && json['last_reading'].isNotEmpty
              ? SensorReadingModel.fromJson(json['last_reading'])
              : null,
      readings: json['readings'] != null
          ? (json['readings'] as List)
              .map((reading) => SensorReadingModel.fromJson(reading))
              .toList()
          : [],
    );
  }
}
