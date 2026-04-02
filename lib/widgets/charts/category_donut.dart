import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/utils/app_theme.dart';

class CategoryDonut extends StatelessWidget {
  final Map<TransactionCategory, double> data;

  const CategoryDonut({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 50,
          sections: data.entries.map((e) => PieChartSectionData(
            color: e.key.color,
            value: e.value,
            title: '${e.value.toStringAsFixed(0)}%',
            radius: 40,
            titleStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white
            ),
          )).toList(),
        ),
      ),
    );
  }
}
