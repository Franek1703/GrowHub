import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';

class GHRefreshIndicator extends StatelessWidget {
  const GHRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: GHColors.black,
      onRefresh: onRefresh,
      backgroundColor: GHColors.white,
      child: child,
    );
  }
}
