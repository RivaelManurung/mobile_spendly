---
description: "Step 4 — Visualisasi Data & Grafik Flutter (fl_chart)"
---

# 📊 STEP 4 — Data Visualization

Bangun grafik interaktif dan premium untuk memantau arus kas mingguan dan pembagian kategori pengeluaran.

## 4a. `lib/widgets/charts/weekly_bar_chart.dart`
Grafik bar 7 hari terakhir yang menunjukkan perbandingan pemasukan (hijau) dan pengeluaran (merah).

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> income;
  final List<double> expense;

  const WeeklyBarChart({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(7, (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(toY: income[i], color: AppTheme.emerald, width: 8),
              BarChartRodData(toY: expense[i], color: AppTheme.rose, width: 8),
            ],
          )),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
```

## 4b. `lib/widgets/charts/category_donut.dart`
Grafik Donut (Pie Chart) yang elegan dengan kategori dan persentase yang mudah dibaca.

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../utils/theme.dart';

class CategoryDonut extends StatelessWidget {
  final Map<TransactionCategory, double> data;

  const CategoryDonut({required this.data});

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
```
