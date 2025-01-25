import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';

class GHSlider extends HookWidget {
  const GHSlider({
    super.key,
    required this.min,
    required this.max,
    required this.startValues,
    required this.onValuesSelected,
  });

  final double min;
  final double max;
  final RangeValues startValues;
  final Function(RangeValues values) onValuesSelected;

  @override
  Widget build(BuildContext context) {
    int getDivisionsNumber() {
      return (max - min) ~/ 20;
    }

    final rangeValue = useState(startValues); // Initial range values

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Ensures it takes up full width
      children: [
        Padding(
          padding: EdgeInsets.zero, // Removes any padding around the slider
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              rangeThumbShape: CustomRangeThumbShape(
                  rangeValue: rangeValue.value), // Custom thumb shape
              activeTrackColor: GHColors.black,
              inactiveTrackColor: GHColors.black.withOpacity(0.6),
              thumbColor: GHColors.black,
            ),
            child: RangeSlider(
              values: rangeValue.value,
              min: min,
              max: max,
              divisions: getDivisionsNumber(),
              onChanged: (RangeValues values) {
                rangeValue.value = values;
                onValuesSelected(values);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  final RangeValues rangeValue;

  const CustomRangeThumbShape({required this.rangeValue});

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
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final canvas = context.canvas;

    // Draw the thumb circle
    final thumbPaint = Paint()..color = sliderTheme.thumbColor!;
    canvas.drawCircle(center, 14, thumbPaint); // Thumb size (radius: 15)

    // Get the value for the thumb dynamically
    final valueText = thumb == Thumb.start
        ? rangeValue.start.toStringAsFixed(0) // Left thumb value
        : rangeValue.end.toStringAsFixed(0); // Right thumb value

    // Draw the value text
    final textSpan = TextSpan(
      text: valueText,
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
