import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/data/models/sensor_model.dart';
import 'package:growhub/features/sensors/widgets/chart.dart';
import 'package:growhub/features/sensors/widgets/date_change_widget.dart';
import 'package:intl/intl.dart';

class SensorCard extends HookWidget {
  final SensorModel sensor;
  final int index;

  const SensorCard({
    super.key,
    required this.sensor,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var startDate = useState(DateTime.now().subtract(const Duration(days: 6)));
    var endDate = useState(DateTime.now());
    String formattedLastReading = sensor.lastSensorReading != null
        ? DateFormat('dd.MM.yyyy, HH:mm')
            .format(sensor.lastSensorReading!.recordedAt)
        : "No data available";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: GHColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: GHColors.black.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(2, 2))
          ]),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Center(
                child: Text(
              sensor.lastSensorReading != null
                  ? "${sensor.name}: ${sensor.lastSensorReading!.value} ${sensor.unit}"
                  : "No data available",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            subtitle:
                Center(child: Text('Last measurement: $formattedLastReading')),
          ),
          SizedBox(
            height: 150,
            child: sensor.readings.isNotEmpty
                ? SensorChart(
                    dataPoints: getChartSpots(
                        Map.fromEntries(sensor.readings.map(
                          (reading) =>
                              MapEntry(reading.recordedAt, reading.value),
                        )),
                        startDate.value,
                        endDate.value),
                    unit: sensor.unit,
                    index: index,
                  )
                : _noDataTemplate(),
          ),
          SlidingDateRange(
            visible: sensor.readings.isNotEmpty,
            onDateRangeChange: (newStartDate, newEndDate) {
              startDate.value = newStartDate;
              endDate.value = newEndDate;
            },
          )
        ],
      ),
    );
  }

  Widget _noDataTemplate() {
    return const Center(
      child: Text(
        "😕",
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  List<FlSpot> getConvertedChartSpots(
      List<MapEntry<DateTime, double>> datapoints) {
    List<FlSpot> points = List<FlSpot>.generate(datapoints.length, (i) {
      final point = datapoints[i];
      final x = point.key.millisecondsSinceEpoch.toDouble();
      final y = point.value;

      return FlSpot(x, y);
    });

    return points;
  }

  List<MapEntry<DateTime, double>> getRangedDataPoints(
      Map<DateTime, double> readings, DateTime startDate, DateTime endDate) {
    List<MapEntry<DateTime, double>> rangedDataPoints =
        readings.entries.where((point) {
      return point.key.isAfter(startDate) &&
          point.key.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    return rangedDataPoints;
  }

  List<FlSpot> getChartSpots(
      Map<DateTime, double> readings, DateTime startDate, DateTime endDate) {
    return getConvertedChartSpots(
        getRangedDataPoints(readings, startDate, endDate));
  }
}
