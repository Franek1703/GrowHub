import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/sensors/models/sensor_model.dart';

class DeviceModel {
  final int id;
  final String name;
  final List<Sensor> sensors;
  final DeviceIcon icon;

  DeviceModel({
    required this.id,
    required this.name,
    required this.sensors,
    required this.icon,
  });
}
