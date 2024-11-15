import 'package:flutter/material.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';

class GHBottomNavBar extends StatelessWidget {
  final Map<String, SvgGenImage>  items;
  const GHBottomNavBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items.entries.map((item) => BottomNavigationBarItem(icon: item.value.svg(), label: item.key)).toList(),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: GHColors().bottomBar,
      
      );
  }
}