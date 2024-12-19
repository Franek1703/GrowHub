import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/device_dashboard/entities/device_icon.dart';

class IconCircle extends HookWidget {
  const IconCircle({
    super.key,
    required this.icon,
    required this.active,
    this.onPressed,
  });

  final DeviceIcon icon;
  final bool active;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);

    return InkWell(
      onTapDown: (_) => isPressed.value = true,
      onTapUp: (_) {
        isPressed.value = false;
        if (onPressed != null) onPressed!();
      },
      onTapCancel: () => isPressed.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? GHColors.primary : null,
          border: Border.all(
            color: active ? GHColors.black : Colors.transparent,
            width: 3,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          icon.path,
          width: 52,
          height: 52,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(GHColors.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}
