import 'package:flutter/material.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';

class GHProgressIndicatorSmall extends StatelessWidget {
  const GHProgressIndicatorSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 0.6,
        child: const GHProgressIndicator(),
      ),
    );
  }
}
