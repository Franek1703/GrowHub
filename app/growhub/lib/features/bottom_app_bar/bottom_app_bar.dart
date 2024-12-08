import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/config/constants/sizes.dart';
import 'package:growhub/features/bottom_app_bar/bottom_bar_icon.dart';
import 'package:growhub/features/bottom_app_bar/cubit/path_cubit.dart';

class GHBottomAppBar extends StatelessWidget {
  final Map<String, SvgGenImage> items;
  const GHBottomAppBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final currentPath = context.watch<PathCubit>().state;
    void onTap(String path) {
      context.read<PathCubit>().onPathChange(path);
      context.go(path);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: GHSizes.bottomBarHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: GHColors.grey,
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 2))
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
                        isTapped: currentPath == item.key,
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
