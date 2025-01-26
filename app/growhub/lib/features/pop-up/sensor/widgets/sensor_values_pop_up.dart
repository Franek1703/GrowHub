import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/range_slider.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/pop-up/dialog.dart';

void showSensorValuesPopupDialog(BuildContext context, Widget popup) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.6),
    context: context,
    builder: (BuildContext context) {
      return popup;
    },
  );
}

class SensorValuesPopUp extends HookWidget {
  const SensorValuesPopUp({
    super.key,
    required this.minSliderValue,
    required this.maxSliderValue,
    required this.sensor,
    required this.onValuesSelected,
  });

  final double minSliderValue;
  final double maxSliderValue;
  final SensorModel sensor;
  final Function(RangeValues values) onValuesSelected;

  @override
  Widget build(BuildContext context) {
    final currentRange =
        useState(RangeValues(sensor.minValue, sensor.maxValue));

    return GHDialog(
      height: MediaQuery.of(context).size.height * 0.6,
      title: "Sensor - ${sensor.name}",
      subtitle: "select acceptable values*",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(height: 10),
          GHRangeSlider(
            min: minSliderValue,
            max: maxSliderValue,
            startValues: RangeValues(sensor.minValue, sensor.maxValue),
            onValuesSelected: (values) {
              currentRange.value = values;
            },
          ),
          Container(height: 30),
          const Text(
            "*so your plants can lead a peaceful life",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onCheckmarkPressed: () {
        onValuesSelected(currentRange.value);
      },
    );
  }
}
