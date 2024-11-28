import 'package:flutter/material.dart';

// Main Padding used on every Growhub page

class GHPagePadding extends StatelessWidget {
  const GHPagePadding({
    super.key,
    required this.child,
    this.top = 0.0,
    this.bottom = 0.0,
  });

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
