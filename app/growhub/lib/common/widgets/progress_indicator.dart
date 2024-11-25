import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class GHProgressIndicator extends HookWidget {
  const GHProgressIndicator({
    super.key,
    this.radius = 40,
    this.strokeWidth = 14,
  });

  final double radius;

  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    const progressIndicatorColor = Colors.grey;
    AnimationController controller =
        useAnimationController(duration: const Duration(seconds: 1))..repeat();

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: GradientCircularProgressIndicator(
        radius: radius,
        gradientColors: [Colors.white, progressIndicatorColor],
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressIndicator extends StatelessWidget {
  const GradientCircularProgressIndicator({
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 10.0,
    super.key,
  });

  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
  });
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    // ignore: cascade_invocations
    paint.shader =
        SweepGradient(colors: gradientColors, startAngle: 0.0, endAngle: 2 * pi)
            .createShader(rect);
    canvas.drawArc(rect, 0.0, 2 * pi, false, paint);

    // Draw circle at the end
    var circlePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = gradientColors.last;

    double endAngle = 2 * pi * 1;
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset circleCenter = Offset(
      center.dx + radius * cos(endAngle) - strokeWidth / 2,
      center.dy + radius * sin(endAngle),
    );
    canvas.drawCircle(circleCenter, strokeWidth / 2, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
