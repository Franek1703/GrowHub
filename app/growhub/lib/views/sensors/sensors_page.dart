import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/features/sensors/models/sensor_model.dart';
import 'package:growhub/features/sensors/widgets/chart.dart';
import 'package:growhub/features/sensors/cubit/sensor_cubit.dart';
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
    var startDate = useState(DateTime.now().subtract(const Duration(days: 15)));
    var endDate = useState(DateTime.now());
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(sensor.name),
            subtitle: Text('Last Reading: ${sensor.lastReading} ${sensor.unit}'),
            trailing: Text(sensor.lastReadingTime),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            child: SensorChart(
              dataPoints: getChartSpots(sensor.readings, startDate.value, endDate.value),
              unit: sensor.unit,
            ),
          ),
        ],
      ),
    );
  }

  

  List<FlSpot> getConvertedChartSpots(List<MapEntry<DateTime, double>> datapoints) {
  List<FlSpot> points = List<FlSpot>.generate(
    datapoints.length,
    (i) {
      final point = datapoints[i];
      final x = point.key.millisecondsSinceEpoch.toDouble();
      final y = point.value;

      return FlSpot(x, y);
    }
  );

  return points;
}

// List<DeimicChartDataPoint> getHourlyAveragedDataPoints(
//     List<DeimicChartDataPoint> datapoints) {
//   Map<DateTime, List<DeimicChartDataPoint>> hourlyData = {};

//   for (var point in datapoints) {
//     DateTime hourKey = DateTime(
//       point.timestamp.year,
//       point.timestamp.month,
//       point.timestamp.day,
//       point.timestamp.hour,
//     );

//     if (!hourlyData.containsKey(hourKey)) {
//       hourlyData[hourKey] = [];
//     }

//     hourlyData[hourKey]!.add(point);
//   }

//   List<DeimicChartDataPoint> averagedPoints = [];

//   hourlyData.forEach((hour, points) {
//     double avgValue =
//         points.map((p) => p.value).reduce((a, b) => a + b) / points.length;

//     averagedPoints.add(DeimicChartDataPoint(
//       hour,
//       avgValue,
//     ));
//   });

//   return averagedPoints;
// }

List<MapEntry<DateTime, double>> getRangedDataPoints(
    Map<String, double> readings,
    DateTime startDate,
    DateTime endDate) {
    Map<DateTime, double> convertedReadings =  readings.map((dateName,value)=> MapEntry(DateTime.parse(dateName), value));
  List<MapEntry<DateTime, double>> rangedDataPoints = convertedReadings.entries.where((point) {
    return point.key.isAfter(startDate) &&
        point.key.isBefore(
            endDate.add(const Duration(days: 1)));
  }).toList();

  return rangedDataPoints;
}

List<FlSpot> getChartSpots(
    Map<String, double> readings, DateTime startDate, DateTime endDate) {

  return getConvertedChartSpots(
    getRangedDataPoints(readings, startDate, endDate));
      
}
}