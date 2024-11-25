import 'package:bloc/bloc.dart';
import 'package:growhub/features/Sensors/models/sensor_model.dart';
import 'package:growhub/features/Sensors/test_data.dart';
import 'package:meta/meta.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  SensorCubit() : super(SensorInitial(sensors: const []));

  void initSensors(List<Sensor> sensors) {
    emit(SensorReadingsLoading(sensors: sensors));

    //Load all sensor readings
    //TODO: Add logic for loading sesor readings
    List<Sensor> updatedSensors = sensors;
    for (var sensor in sensors) {
      sensor.updateReadings(testReadings);
    }
    emit(SensorReadingsLoaded(sensors: sensors));
  }

  void updateSensors(){
    //TODO: Add logic for updating sensors
  }
}
