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

      emit(SensorStateLoaded(sensors));
    } catch (e) {
      emit(SensorStateError(error: e.toString()));
    }
  }

  Future<void> updateSensor({
    required int sensorId,
    double? minValue,
    double? maxValue,
    double? measurementFrequency,
  }) async {
    final state = this.state;

    if (state is! SensorStateLoaded) {
      return;
    }
    emit(SensorStateLoading(sensors: state.sensors));

    try {
      final token = await apiRepository.getToken();
      if (token == null) {
        emit(SensorStateInitial());
        return;
      }

      await apiRepository.updateSensor(
        token: token,
        sensorId: sensorId,
        minValue: minValue,
        maxValue: maxValue,
        measurementFrequency: measurementFrequency,
      );

      // Znajdź urządzenie w aktualnym stanie
      final sensor = findSensorById(state.sensors, sensorId);
      if (sensor == null) {
        emit(SensorStateError(error: "No devices found."));
        return;
      }

      final updatedSensor = sensor.copyWith(
        minValue: minValue ?? sensor.minValue,
        maxValue: maxValue ?? sensor.maxValue,
      );

      final updatedSensors = [
        for (final s in state.sensors)
          if (s.id == sensorId) updatedSensor else s,
      ];

      emit(SensorStateLoaded(updatedSensors));
    } catch (e) {
      emit(SensorStateError(error: e.toString()));
    }
  }

  SensorModel? findSensorById(List<SensorModel> sensors, int id) {
    try {
      return sensors.firstWhere((sensor) => sensor.id == id);
    } catch (e) {
      return null;
    }
  }
}
