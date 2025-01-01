import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/slider.dart';
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
    required this.sensor,
  });

  final SensorModel sensor;

  @override
  Widget build(BuildContext context) {
    return GHDialog(
      title: "Sensor - ${sensor.name}",
      subtitle: "select acceptable values*",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          GHSlider(),
          Container(height: 50),
          Text("*so your plants can live a peaceful life"),
        ],
      ),
      onCheckmarkPressed: () {},
    );
  }
}
