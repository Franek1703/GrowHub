import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';

class DeviceModel {
  final int id;
  final String name;
  final List<SensorModel> sensors;
  final DeviceIcon icon;

  DeviceModel({
    required this.id,
    required this.name,
    required this.sensors,
    required this.icon,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['device_id'],
      name: json['name'],
      sensors: List<SensorModel>.from(
        json['sensors'].map((x) => SensorModel.fromJson(x)),
      ),
      icon: DeviceIcon.fromIndex(json['icon']),
    );
  }

  DeviceModel copyWith({
    int? id,
    String? name,
    List<SensorModel>? sensors,
    DeviceIcon? icon,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sensors: sensors ?? this.sensors,
      icon: icon ?? this.icon,
    );
  }
}
