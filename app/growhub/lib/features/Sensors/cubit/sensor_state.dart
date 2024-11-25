part of 'sensor_cubit.dart';

@immutable
sealed class SensorState {
  final List<Sensor> sensors;

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

