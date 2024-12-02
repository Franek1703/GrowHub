import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/api/data/models/sensor_reading_model.dart';

import 'package:growhub/features/sensors/test_data.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  SensorCubit() : super(SensorInitial(sensors: const []));

  void initSensors(List<SensorModel> sensors) {
    emit(SensorReadingsLoading(sensors: sensors));
    Future.delayed(const Duration(seconds: 2), () {
      //Load all sensor readings
      //TODO: Add logic for loading sesor readings

      final readings = testReadings.entries.map((entry) {
        return SensorReadingModel(
          id: 0,
          recordedAt: entry.key,
          value: entry.value,
        );
      }).toList();
      for (var sensor in sensors) {
        sensor.readings = readings;
      }
      emit(SensorReadingsLoaded(sensors: sensors));
    });
  }

  Future<void> updateSensors() async {
    //TODO: Add logic for updating sensors
  }
}
