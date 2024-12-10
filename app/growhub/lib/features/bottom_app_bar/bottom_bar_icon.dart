import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';

class BottomBarIcon extends HookWidget {
  const BottomBarIcon({
    super.key,
    required this.icon,
    required this.path,
    required this.isTapped,
    required this.onTap,
  });

  final SvgGenImage icon;
  final bool isTapped;
  final String path;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () => onTap(),
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isTapped ? GHColors.white : Colors.transparent,
        ),
        child: Center(
          child: icon.svg(
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              isTapped ? GHColors.black : GHColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
