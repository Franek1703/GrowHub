import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    required this.icon,
  });

  final DeviceIcon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: GHColors.black,
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        width: 50,
        height: 50,
        icon.path,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(GHColors.black, BlendMode.srcIn),
      ),
    );
  }
}
