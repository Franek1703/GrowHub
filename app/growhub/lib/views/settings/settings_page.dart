import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/device/device_cubit.dart';
import 'package:growhub/features/api/data/models/device_model.dart';
import 'package:growhub/features/pop-up/icon-choice/widgets/icon_pop_up.dart';

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
    print(deviceId);
    return Scaffold(
      backgroundColor: GHColors.background,
      body: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          if (getDevices(state) == null) {
            return const GHProgressIndicator();
          }
          final device = context
              .watch<DeviceCubit>()
              .findDeviceById(getDevices(state)!, deviceId);

          if (device == null) {
            return const GHProgressIndicator();
          }

          return Center(
            child: GestureDetector(
              onTap: () {
                showIconPopupDialog(
                  context,
                  IconPopUp(
                    startIcon: device.icon,
                    onIconSelected: (icon) {
                      print(icon);
                      context
                          .read<DeviceCubit>()
                          .updateDevice(deviceId: deviceId, icon: icon);
                    },
                  ),
                );
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: SvgPicture.asset(
                  device.icon.path,
                  fit: BoxFit.contain,
                  colorFilter:
                      ColorFilter.mode(GHColors.black, BlendMode.srcIn),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
