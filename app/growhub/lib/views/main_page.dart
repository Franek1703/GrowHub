import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/features/bottom_navigation_bar/bottom_navigation_bar_widget.dart';

class MainPage extends HookWidget {
  final Widget child;
  final String path;
  const MainPage({super.key, required this.child, required this.path});

  @override
  Widget build(BuildContext context) {
    late Map<String, SvgGenImage> items;
    if(path.contains("/dashboard/")){
      items = {
      "/dashboard/calendar": Assets.iconsUi.calendar,
      "/dashboard/sensor" : Assets.iconsUi.thermometer,
      "/dashboard/settings" : Assets.iconsUi.settings,
      };
    }
    else{
      items = {
      "/profile": Assets.iconsUi.user,
      "/dashboard": Assets.iconsUi.leaf,
      "/notification": Assets.iconsUi.bell
    };
    }
    
    return Scaffold(
      body: Stack(
        children: [
          child,
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: GHBottomNavBar(
              items: items,
            ),
          ),
        ],
      ),
    );
  }
}
