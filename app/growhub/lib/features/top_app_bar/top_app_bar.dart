import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/config/constants/sizes.dart';

class GHTopAppBar extends StatelessWidget implements PreferredSizeWidget{

  final String title;
  final VoidCallback? onLeadingPressed;
  final bool showLeading;

  const GHTopAppBar({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.showLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: GHSizes.topBarHeight,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: GHColors.black,
        ),
      ),
      leading: showLeading 
        ? IconButton(
            icon: Icon(Icons.close, color: GHColors.black),
            onPressed: onLeadingPressed,
          )
        :null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(GHSizes.topBarHeight);
}