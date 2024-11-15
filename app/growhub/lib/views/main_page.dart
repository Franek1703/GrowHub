import 'package:flutter/material.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/bottom_navigation_bar/bottom_navigation_bar_widget.dart';

class MainPage extends StatelessWidget {
   final Widget child;
  const MainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final items = {
      "/profile" : Assets.iconsUi.user,
      "/dashboard": Assets.iconsUi.leaf,
      "/notification" : Assets.iconsUi.bell
    };
    return Scaffold(
      bottomNavigationBar: GHBottomNavBar(items: items,),
      body: child,
    );
  }
}