import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.icon,
    required this.active,
  });

  final DeviceIcon icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? GHColors.primary : null,
        border: active ? Border.all(color: GHColors.black, width: 4) : null,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        icon.path,
        width: 54,
        height: 54,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(GHColors.black, BlendMode.srcIn),
      ),
    );
  }
}
