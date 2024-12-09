part of 'sensor_cubit.dart';

abstract class SensorState {}

final class SensorStateInitial extends SensorState {}

final class SensorStateLoading extends SensorState {
  List<SensorModel>? sensors;

  SensorStateLoading({this.sensors});
}

final class SensorStateLoaded extends SensorState {
  final List<SensorModel> sensors;

  SensorStateLoaded(this.sensors);
}

final class SensorStateError extends SensorState {
  final String error;

  SensorStateError({required this.error});
}
