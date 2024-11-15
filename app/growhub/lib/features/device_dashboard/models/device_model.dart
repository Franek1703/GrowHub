import 'package:growhub/features/Sensors/models/sensor_model.dart';

class Device {
  final String name;
  final List<Sensor> sensors;

  Device({
    required this.name,
    required this.sensors,
  });
}
