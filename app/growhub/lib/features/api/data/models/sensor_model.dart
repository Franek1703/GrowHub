import 'package:growhub/features/api/data/models/sensor_reading_model.dart';

class SensorModel {
  final String name;
  final String unit;
  final SensorReadingModel lastSensorReading;

  final List<SensorReadingModel>? readings;

  SensorModel({
    required this.name,
    required this.unit,
    required this.lastSensorReading,
    this.readings,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      name: json['sensor_type'],
      unit: json["unit"],
      lastSensorReading: SensorReadingModel.fromJson(json['last_reading']),
    );
  }
}
