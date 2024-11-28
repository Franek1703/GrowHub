
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/all_purpose_widgets/widgets/gradient_circular_progress_indicator.dart';


class GHProgressIndicatorWithText extends HookWidget {
  const GHProgressIndicatorWithText({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    AnimationController controller =
        useAnimationController(duration: const Duration(seconds: 1));

    controller.repeat();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
            child: GradientCircularProgressIndicator(
              radius: 40,
              gradientColors: [
                GHColors.white,
                const Color(0xff4D91FF),
              ],
              strokeWidth: 14.0,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text ?? "Loading",
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}


class GHProgressIndicator extends HookWidget {
  const GHProgressIndicator({super.key,
  this.radius = 40,
  this.strokeWidth = 14,
  });

  final double radius;

  final double strokeWidth;


  @override
  Widget build(BuildContext context) {
    AnimationController controller =
        useAnimationController(duration: const Duration(seconds: 1));

    controller.repeat();
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: GradientCircularProgressIndicator(
        radius: radius,
        gradientColors: [
          GHColors.white,
          const Color(0xff4D91FF),
        ],
        strokeWidth: strokeWidth,
      ),
    );
  }
}