part of 'sensor_cubit.dart';

sealed class SensorState {
  final List<SensorModel> sensors;

  SensorState({required this.sensors});
}

final class SensorInitial extends SensorState {
  SensorInitial({required super.sensors});
}

final class SensorReadingsLoading extends SensorState {
  SensorReadingsLoading({required super.sensors});
}

final class SensorReadingsLoaded extends SensorState {
  SensorReadingsLoaded({required super.sensors});
}
