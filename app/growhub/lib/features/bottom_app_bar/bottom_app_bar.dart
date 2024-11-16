import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/config/constants/sizes.dart';
import 'package:growhub/features/bottom_app_bar/bottom_bar_icon.dart';

class GHBottomAppBar extends HookWidget {
  final Map<String, SvgGenImage> items;
  const GHBottomAppBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final currentPath = useState(items.entries.elementAt(1).key);
    void onTap(String path) {
      currentPath.value = path;
      context.go(path);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: GHSizes().bottomBarHeight,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(2, 2))
        ],
        color: GHColors.black,
        borderRadius: const BorderRadius.all(Radius.circular(35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.entries
                  .map((item) => BottomBarIcon(
                        icon: item.value,
                        path: item.key,
                        isTapped: currentPath.value == item.key,
                        onTap: () => onTap(item.key),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
