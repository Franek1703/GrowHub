import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/sensors/models/sensor_model.dart';
import 'package:growhub/features/device_dashboard/models/device_model.dart';
part 'device_cubit_state.dart';

class DeviceCubit extends Cubit<DeviceCubitState> {
  DeviceCubit() : super(DeviceCubitInitial(const []));

  void loadDevices() {
    emit(DeviceCubitLoaded(devices));
  }

  //TODO: Test devices Delet it
  List<DeviceModel> devices = [
    DeviceModel(
      id: 0,
      name: "FirstDevice",
      icon: DeviceIcon.flower1,
      sensors: [
        Sensor(
            lastReading: 23.4,
            name: "PH",
            unit: 'pH',
            lastReadingTime: 123456,
            readings: {}),
        Sensor(
          lastReading: 23.4,
          name: "Temperature",
          unit: 'C',
          lastReadingTime: 123456,
          readings: {},
        ),
        Sensor(
            lastReading: 23.4,
            name: "TDS",
            unit: 'ppm',
            lastReadingTime: 123456,
            readings: {})
      ],
    ),
    DeviceModel(
      id: 1,
      name: "SecondDevice",
      icon: DeviceIcon.cactus,
      sensors: [
        Sensor(
            lastReading: 23.4,
            name: "PH",
            unit: 'pH',
            lastReadingTime: 123456,
            readings: {}),
        Sensor(
          lastReading: 23.4,
          name: "Temperature",
          unit: 'C',
          lastReadingTime: 123456,
          readings: {},
        ),
        Sensor(
            lastReading: 23.4,
            name: "TDS",
            unit: 'ppm',
            lastReadingTime: 123456,
            readings: {})
      ],
    ),
    DeviceModel(
      id: 2,
      name: "ThirdDevice",
      icon: DeviceIcon.daisy,
      sensors: [
        Sensor(
            lastReading: 23.4,
            name: "PH",
            unit: 'pH',
            lastReadingTime: 123456,
            readings: {}),
        Sensor(
          lastReading: 23.4,
          name: "Temperature",
          unit: 'C',
          lastReadingTime: 123456,
          readings: {},
        ),
        Sensor(
            lastReading: 23.4,
            name: "TDS",
            unit: 'ppm',
            lastReadingTime: 123456,
            readings: {})
      ],
    ),
  ];
}
