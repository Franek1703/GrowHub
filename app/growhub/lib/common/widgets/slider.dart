import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';

class GHSlider extends HookWidget {
  const GHSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final value = useState(40.0);

    return Container(
      child: Slider(
        value: value.value,
        max: 100,
        divisions: 5,
        label: value.value.round().toString(),
        onChanged: (double v) {
          value.value = v;
        },
        activeColor: GHColors.black,
        inactiveColor: GHColors.black.withOpacity(0.5),
      ),
    );
  }
}
