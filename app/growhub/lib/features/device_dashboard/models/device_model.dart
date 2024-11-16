import 'package:growhub/features/Sensors/models/sensor_model.dart';

class DeviceModel {
  final String name;
  final List<Sensor> sensors;

  DeviceModel({
    required this.name,
    required this.sensors,
  });
}
