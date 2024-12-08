part of 'device_cubit.dart';

abstract class DeviceState {}

final class DeviceStateInitial extends DeviceState {}

final class DeviceStateLoading extends DeviceState {
  Set<DeviceModel>? devices;

  DeviceStateLoading({this.devices});
}

final class DeviceStateLoaded extends DeviceState {
  final Set<DeviceModel> devices;

  DeviceStateLoaded(this.devices);
}

final class DeviceStateError extends DeviceState {
  final String error;

  DeviceStateError({required this.error});
}
