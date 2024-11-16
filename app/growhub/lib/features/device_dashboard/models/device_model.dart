import 'package:growhub/features/sensors/models/sensor_model.dart';

class DeviceModel {
  final String name;
  final List<Sensor> sensors;

  DeviceModel({
    required this.name,
    required this.sensors,
  });
}
