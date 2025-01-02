import 'package:growhub/features/api/data/models/sensor_reading_model.dart';

class SensorModel {
  final int id;
  final String name;
  final String unit;
  final double minValue;
  final double maxValue;
  final SensorReadingModel? lastSensorReading;

  List<SensorReadingModel> readings;

  SensorModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.lastSensorReading,
    this.readings = const [],
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['sensor_id'],
      name: json['sensor_type'],
      unit: json["unit"],
      minValue: json["min_value"],
      maxValue: json["max_value"],
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

  SensorReadingModel? getLatestReading() {
    if (readings.isEmpty) {
      return null;
    }
    // Sort readings by recordedAt in descending order
    readings.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return readings.first;
  }

  SensorModel copyWith({
    int? id,
    String? name,
    String? unit,
    double? minValue,
    double? maxValue,
    SensorReadingModel? lastSensorReading,
    List<SensorReadingModel>? readings,
  }) {
    return SensorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      lastSensorReading: lastSensorReading ?? this.lastSensorReading,
      readings: readings ?? this.readings,
    );
  }
}
