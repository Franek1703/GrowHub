import 'package:flutter_bloc/flutter_bloc.dart';

part 'config_data.dart';

class ConfigDataCubit extends Cubit<ConfigData> {
  ConfigDataCubit() : super(const ConfigData(currentDeviceId: 0));

  void setCurrentDeviceId(int deviceId) {
    emit(state.copyWith(currentDeviceId: deviceId));
  }
}
