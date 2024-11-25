import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';

class SensorChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final String unit;

  SensorChart({required this.dataPoints, required this.unit});

  @override
  Widget build(BuildContext context) {
    Set<String> shownYLabels = {};

    return LineChart(
      LineChartData(
        // borderData: FlBorderData(
        //   border: Border(
        //     bottom: BorderSide(
        //       width: 1.6,
        //       color: context.colors.primary.withOpacity(0.5),
        //     ),
        //     left: BorderSide(
        //       width: 1.6,
        //       color: context.colors.primary.withOpacity(0.5),
        //     ),
        //   ),
        // ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                shownYLabels.add(value.floor().toString());

                if (!shownYLabels.contains(meta.formattedValue)) {
                  return const SizedBox();
                }
                return Text(
                  '${meta.formattedValue}$unit',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                DateTime dateTime =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                if (meta.axisPosition == 0.0) {
                  return SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${dateTime.day.toInt()}',
                    style: TextStyle(
                      // color: context.colors.primary.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(
          show: true,
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                GHColors.primary,
            tooltipPadding:
                EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((LineBarSpot spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}$unit', TextStyle()
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            color: GHColors.primary,
            show: true,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            barWidth: 2,
            spots: dataPoints,
          ),
        ],
      ),
    );
  }
}
    // LineChart(
    //   LineChartData(
    //     lineBarsData: [
    //       LineChartBarData(
    //         spots: dataPoints,
    //         isCurved: true,
    //         color: GHColors.black,
    //         barWidth: 4,
    //         belowBarData: BarAreaData(show: false),
    //       ),
    //     ],
    //     titlesData: FlTitlesData(
    //       bottomTitles: SideTitles(showTitles: true),
    //       leftTitles: SideTitles(showTitles: true),
    //     ),
    //   ),
    // );
//   }
// }
