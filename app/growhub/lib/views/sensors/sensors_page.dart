import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/Sensors/widgets/date_change_widget.dart';
import 'package:growhub/features/sensors/models/sensor_model.dart';
import 'package:growhub/features/sensors/widgets/chart.dart';
import 'package:growhub/features/sensors/cubit/sensor_cubit.dart';
import 'package:intl/intl.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorCubit, SensorState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.sensors.length,
          itemBuilder: (context, index) {
            final sensor = state.sensors[index];
            return SensorCard(sensor: sensor);
          },
        );
      },
    );
  }
}

class SensorCard extends HookWidget {
  final Sensor sensor;

  SensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    var startDate = useState(DateTime.now().subtract(const Duration(days: 6)));
    var endDate = useState(DateTime.now());
    String formattedLastReading = DateFormat('dd.MM.yyyy, HH:mm').format(sensor.lastReadingTime);
    return Container(

      decoration: BoxDecoration(
        color: GHColors.white,
        borderRadius: BorderRadius.circular(30)
      ),
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Center(
                child: Text(
                    "${sensor.name}: ${sensor.lastReading} ${sensor.unit}", style: const TextStyle(fontWeight: FontWeight.bold),)),
            subtitle: Center(
                child: Text('Last measurement: ${formattedLastReading}')),
          ),
          Container(
            height: 150,
            padding: EdgeInsets.all(16),
            child: SensorChart(
              dataPoints: getChartSpots(
                  sensor.readings, startDate.value, endDate.value),
              unit: sensor.unit,
            ),
          ),
          SlidingDateRange(onDateRangeChange: (newStartDate, newEndDate) {
            startDate.value = newStartDate;
            endDate.value = newEndDate;
          },)
        ],
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
