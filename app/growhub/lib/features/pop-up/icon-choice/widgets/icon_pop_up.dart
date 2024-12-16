import 'package:flutter/material.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';
import 'package:growhub/features/pop-up/dialog.dart';
import 'package:growhub/features/pop-up/icon-choice/widgets/icon_circle.dart';

class IconPopUp extends StatelessWidget {
  const IconPopUp({
    super.key,
    required this.currentIcon,
    required this.onIconSelected,
  });

  final DeviceIcon currentIcon;
  final Function(DeviceIcon icon) onIconSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GHDialog(
              title: "Choose icon",
              body: Wrap(
                children: [
                  ...DeviceIcon.values.map(
                    (icon) => IconCircle(
                      icon: icon,
                      active: currentIcon == icon,
                    ),
                  )
                ],
              ),
              onCheckmarkPressed: () {},
            );
          },
        );
      },
      child: Container(
        child: Assets.kwiatki.daisySvgrepoCom.svg(
          height: 24,
          colorFilter: ColorFilter.mode(
            GHColors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
