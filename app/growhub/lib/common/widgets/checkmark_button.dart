import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';

class CheckmarkButton extends HookWidget {
  const CheckmarkButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);

    return GestureDetector(
      onTapDown: (_) => isPressed.value = true,
      onTapUp: (_) {
        isPressed.value = false;
        if (onPressed != null) onPressed!();
      },
      onTapCancel: () => isPressed.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Slightly scale up when pressed
        width: isPressed.value ? 58 : 56,
        height: isPressed.value ? 58 : 56,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: GHColors.black,
          shape: BoxShape.circle,
          boxShadow: isPressed.value
              ? [
                  BoxShadow(
                    color: GHColors.black.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Assets.iconsUi.checkmark.svg(
          colorFilter: ColorFilter.mode(
            GHColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
