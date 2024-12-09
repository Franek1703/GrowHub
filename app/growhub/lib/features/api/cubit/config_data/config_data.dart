part of 'config_data_cubit.dart';

class ConfigData {
  const ConfigData({
    required this.currentDeviceId,
  });

  final int currentDeviceId;

  ConfigData copyWith({int? currentDeviceId}) {
    return ConfigData(
      currentDeviceId: currentDeviceId ?? this.currentDeviceId,
    );
  }
}
