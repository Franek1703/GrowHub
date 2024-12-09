import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
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

  // Future<void> loadSensorReadings() {

  // }
}
