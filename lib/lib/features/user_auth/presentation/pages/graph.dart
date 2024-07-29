import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StyledGraph extends StatelessWidget {
  final List<FlSpot> dataPoints;

  StyledGraph({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(
              show: false,
            ),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    );
                    return Text(value.toInt().toString(), style: style);
                  },
                  interval: 5, // Adjust based on your data
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // Adjust based on your data
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [
                    Color(0x802e1b6c),
                    Color(0xFFbbb0ea),

                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                barWidth: 4,
                dotData: FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Color(0x802e1b6c)

                          .withOpacity(0.2),
                      Color(0xFFbbb0ea).withOpacity(0.2),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
