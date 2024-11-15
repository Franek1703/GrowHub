import 'package:flutter/material.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/bottom_navigation_bar/bottom_navigation_bar_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = {
      "/profile" : Assets.iconsUi.user,
      "/dashboard": Assets.iconsUi.leaf,
      "/notification" : Assets.iconsUi.bell
    };
    return Scaffold(
      backgroundColor: GHColors().background,
      bottomNavigationBar: GHBottomNavBar(items: items,),
    );
  }
}