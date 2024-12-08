import 'dart:io';

class SensorReadingModel {
  int id;
  DateTime recordedAt;
  double value;

  SensorReadingModel({
    required this.id,
    required this.recordedAt,
    required this.value,
  });

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return SensorReadingModel(
      id: json["reading_id"],
      recordedAt: HttpDate.parse(json["recorded_at"]),
      value: json["value"],
    );
  }
}
