import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/data/models/sensor_reading_model.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
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
        SensorModel(
          id: 0,
          name: "PH",
          unit: 'pH',
          lastSensorReading:
              SensorReadingModel(id: 0, recordedAt: DateTime.now(), value: 0),
        ),
        SensorModel(
          id: 0,
          name: "PH",
          unit: 'pH',
          lastSensorReading:
              SensorReadingModel(id: 0, recordedAt: DateTime.now(), value: 0),
        ),
      ],
    ),
  ];
}
