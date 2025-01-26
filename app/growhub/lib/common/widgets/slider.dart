import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';

class GHSlider extends HookWidget {
  const GHSlider({
    super.key,
    required this.min,
    required this.max,
    required this.startValue,
    required this.onValueSelected,
  });

  final double min;
  final double max;
  final double startValue;
  final Function(double value) onValueSelected;

  @override
  Widget build(BuildContext context) {
    final currentValue = useState(startValue);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: CustomSliderThumbShape(value: currentValue.value),
            activeTrackColor: GHColors.black,
            inactiveTrackColor: GHColors.black.withOpacity(0.6),
            thumbColor: GHColors.black,
            trackHeight: 5,
          ),
          child: Slider(
            min: min,
            max: max,
            divisions: 4,
            value: currentValue.value,
            onChanged: (value) {
              currentValue.value = value;
              onValueSelected(value);
            },
          ),
        ),
      ],
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double value;

  const CustomSliderThumbShape({required this.value});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(40, 40); // Size of the thumb
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Draw the thumb circle
    final thumbPaint = Paint()..color = sliderTheme.thumbColor!;
    canvas.drawCircle(center, 14, thumbPaint); // Thumb size (radius: 14)

    // Draw the value text
    final valueText = this.value.toStringAsFixed(0); // Round value to integer

    final textSpan = TextSpan(
      text: "${valueText}s",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
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
