import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
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
      onPressed: () {
        onTap();
        context.go(path);
      },
      icon: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isTapped ? GHColors.white : Colors.transparent,
        ),
        child: icon.svg(
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
                isTapped ? GHColors.bottomBar : GHColors.white,
                BlendMode.srcIn)),
      ),
    );
  }
}
