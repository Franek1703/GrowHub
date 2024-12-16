import 'package:flutter/material.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/pop-up/icon-choice/widgets/icon_pop_up.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: IconPopUp(
        currentIcon: DeviceIcon.cactus,
        onIconSelected: (icon) {},
      ),
    );
  }
}
