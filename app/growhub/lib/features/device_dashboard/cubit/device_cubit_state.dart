part of 'device_cubit_cubit.dart';

abstract class DeviceCubitState {
  final List<DeviceModel> devices;

  DeviceCubitState(this.devices);
}

final class DeviceCubitInitial extends DeviceCubitState {
  DeviceCubitInitial(super.devices);
}

final class DeviceCubitLoading extends DeviceCubitState {
  DeviceCubitLoading(super.devices);
}

final class DeviceCubitLoaded extends DeviceCubitState {
  DeviceCubitLoaded(super.devices);
}
