import 'package:flutter_bloc/flutter_bloc.dart';
part 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  DeviceCubit() : super(DeviceInitial());
}
