import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growhub/features/api/cubit/device/device_cubit.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/pop-up/icon-choice/widgets/icon_pop_up.dart';
import 'package:growhub/features/settings/widgets/circular_icon.dart';

class PlantPopIcon extends StatelessWidget {
  const PlantPopIcon({
    super.key,
    required this.deviceId,
    required this.icon,
  });

  final int deviceId;
  final DeviceIcon icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showIconPopupDialog(
          context,
          IconPopUp(
            startIcon: icon,
            onIconSelected: (icon) {
              print(icon);
              context
                  .read<DeviceCubit>()
                  .updateDevice(deviceId: deviceId, icon: icon);
            },
          ),
        );
      },
      child: CircularIcon(
        icon: icon,
      ),
    );
  }
}
