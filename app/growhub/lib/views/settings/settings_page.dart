import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/pop-up/icon-choice/widgets/icon_pop_up.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: GestureDetector(
        onTap: () {
          showIconPopupDialog(
            context,
            IconPopUp(
              startIcon: DeviceIcon.cactus,
              onIconSelected: (icon) {},
            ),
          );
        },
        child: SizedBox(
          width: 50,
          height: 50,
          child: Assets.kwiatki.daisySvgrepoCom.svg(
            height: 24,
            colorFilter: ColorFilter.mode(
              GHColors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
