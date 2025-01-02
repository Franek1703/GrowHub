import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';

class GHSlider extends HookWidget {
  const GHSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final value = useState(40.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: CustomSliderThumb(value.value), // Custom thumb shape
            activeTrackColor: GHColors.black,
            inactiveTrackColor: GHColors.black.withOpacity(0.5),
            thumbColor: GHColors.black,
          ),
          child: Slider(
            value: value.value,
            max: 100,
            divisions: 20,
            onChanged: (double v) {
              value.value = v;
            },
          ),
        ),
      ],
    );
  }
}

class CustomSliderThumb extends SliderComponentShape {
  final double value;

  CustomSliderThumb(this.value);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(80, 80); // Rozmiar thumb
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Draw the circle for the thumb
    final thumbPaint = Paint()..color = sliderTheme.thumbColor!;
    canvas.drawCircle(center, 14, thumbPaint);

    // Draw the value text
    final textSpan = TextSpan(
      text: this.value.round().toString(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
}
