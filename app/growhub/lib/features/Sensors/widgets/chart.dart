import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:growhub/config/constants/colors.dart';

class SensorChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final String unit;
  final int index;

  const SensorChart(
      {super.key,
      required this.dataPoints,
      required this.unit,
      required this.index});

  @override
  Widget build(BuildContext context) {
    Set<String> shownYLabels = {};
    final gradientColors = [
      GHColors.redC,
      GHColors.primary,
      GHColors.purpleC,
      GHColors.blueC,
      GHColors.amberC,
      GHColors.cyanC,
      GHColors.yellowC
    ];
    final gradientColor = gradientColors[index % gradientColors.length];
    return dataPoints.isEmpty
        ? _noDataTemplate()
        : LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      shownYLabels.add(value.floor().toString());

                      if (!shownYLabels.contains(meta.formattedValue)) {
                        return const SizedBox();
                      }
                      return Text(
                        '${meta.formattedValue}$unit',
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
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
                show: false,
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => gradientColor,
                  tooltipPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((LineBarSpot spot) {
                      return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)}$unit', TextStyle());
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  color: GHColors.black,
                  show: true,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                          stops: [0.2, 0.95],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [gradientColor, GHColors.white])),
                  barWidth: 2,
                  spots: dataPoints,
                ),
              ],
            ),
          );
  }

  Widget _noDataTemplate() {
    return const Center(
      child: Text(
        textAlign: TextAlign.center,
        "No readings in this range\n🙃",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
