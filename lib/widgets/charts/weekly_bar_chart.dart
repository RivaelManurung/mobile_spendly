import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_spendly/utils/app_theme.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> income;
  final List<double> expense;
  final Color incomeColor;
  final Color expenseColor;
  final Color incomeDimColor;
  final Color expenseDimColor;

  const WeeklyBarChart({
    super.key, 
    required this.income, 
    required this.expense,
    this.incomeColor = AppTheme.emerald,
    this.expenseColor = AppTheme.rose,
    this.incomeDimColor = Colors.green,
    this.expenseDimColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(7, (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(toY: income[i], color: incomeColor, width: 8),
              BarChartRodData(toY: expense[i], color: expenseColor, width: 8),
            ],
          )),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(days[value.toInt()], style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
