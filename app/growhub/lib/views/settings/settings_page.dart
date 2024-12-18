import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/progress_indicator_small.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/device/device_cubit.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/settings/widgets/plant_pop_icon.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({
    super.key,
    required this.deviceId,
  });

  final int deviceId;

  Set<DeviceModel>? getDevices(DeviceState from) {
    final state = from;

    if (state is DeviceStateLoaded) {
      return state.devices;
    }

    if (state is DeviceStateLoading) {
      return state.devices;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GHColors.background,
      body: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          if (getDevices(state) == null) {
            return const GHProgressIndicatorSmall();
          }
          final device = context
              .watch<DeviceCubit>()
              .findDeviceById(getDevices(state)!, deviceId);

          if (device == null) {
            return const GHProgressIndicatorSmall();
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: PlantPopIcon(
                deviceId: deviceId,
                icon: device.icon,
              )),
            ],
          );
        },
      ),
    );
  }
}
