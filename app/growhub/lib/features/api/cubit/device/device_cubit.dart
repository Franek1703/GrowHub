import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
part 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final ApiRepository apiRepository;

  DeviceCubit(this.apiRepository) : super(DeviceStateInitial());

  Future<void> loadData() async {
    final state = this.state;
    if (state is DeviceStateLoaded) {
      DeviceStateLoading(devices: state.devices);
    } else {
      emit(DeviceStateLoading());
    }

    try {
      final token = await apiRepository.getToken();

      if (token == null) {
        emit(DeviceStateInitial());
        return;
      }

      final devices = await apiRepository.getConfiguration(token);

      emit(DeviceStateLoaded(devices));
    } catch (e) {
      emit(DeviceStateError(error: e.toString()));
    }
  }

  Future<void> updateDevice({
    required int deviceId,
    DeviceIcon? icon,
    String? location,
    String? name,
  }) async {
    final state = this.state;

    if (state is! DeviceStateLoaded) {
      return;
    }
    emit(DeviceStateLoading(devices: state.devices));

    try {
      final token = await apiRepository.getToken();
      if (token == null) {
        emit(DeviceStateInitial());
        return;
      }

      await apiRepository.updateDevice(
        token: token,
        deviceId: deviceId,
        icon: icon,
        location: location,
        name: name,
      );

      // Znajdź urządzenie w aktualnym stanie
      final device = findDeviceById(state.devices, deviceId);
      if (device == null) {
        emit(DeviceStateError(error: "No devices found."));
        return;
      }

      final updatedDevice = device.copyWith(
        icon: icon ?? device.icon,
        name: name ?? device.name,
        location: location ?? device.location,
      );

      final updatedDevices = {
        for (final d in state.devices)
          if (d.id == deviceId) updatedDevice else d,
      };

      print(icon);

      emit(DeviceStateLoaded(updatedDevices));
    } catch (e) {
      emit(DeviceStateError(error: e.toString()));
    }
  }

  DeviceModel? findDeviceById(Set<DeviceModel> devices, int id) {
    try {
      return devices.firstWhere((device) => device.id == id);
    } catch (e) {
      return null;
    }
  }
}
