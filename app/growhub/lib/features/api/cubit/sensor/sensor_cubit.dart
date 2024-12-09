import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/api_repository.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final ApiRepository apiRepository;

  SensorCubit(this.apiRepository) : super(SensorStateInitial());

  Future<void> loadSensorReadings(int deviceId) async {
    final state = this.state;
    if (state is SensorStateLoaded) {
      SensorStateLoading(sensors: state.sensors);
    } else {
      emit(SensorStateLoading());
    }

    try {
      final token = await apiRepository.getToken();

      if (token == null) {
        emit(SensorStateInitial());
        return;
      }

      final sensors =
          await apiRepository.getSensorsWithReadings(token, deviceId);

      print(sensors);
      emit(SensorStateLoaded(sensors));
    } catch (e) {
      print(e);
      emit(SensorStateError(error: e.toString()));
    }
  }
}
