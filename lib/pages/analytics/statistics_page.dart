import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/widgets/charts/category_donut.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/widgets/charts/weekly_bar_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Statistik Keuangan', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final transactions = state.transactions;
          final stats = state.monthlyStats;
          
          // --- REAL WEEKLY DATA CALCULATION ---
          final now = DateTime.now();
          final List<double> weeklyIncome = List.filled(7, 0.0);
          final List<double> weeklyExpense = List.filled(7, 0.0);
          
          for (int i = 0; i < 7; i++) {
            final day = now.subtract(Duration(days: 6 - i));
            final dayIncome = transactions
                .where((t) => isSameDay(t.date, day) && t.type == TransactionType.income)
                .fold(0.0, (s, t) => s + t.amount);
            final dayExpense = transactions
                .where((t) => isSameDay(t.date, day) && t.type == TransactionType.expense)
                .fold(0.0, (s, t) => s + t.amount);
            
            weeklyIncome[i] = dayIncome / 100000; // Scaling for chart visibility if needed, or use raw
            weeklyExpense[i] = dayExpense / 100000;
          }

          // --- REAL CATEGORY BREAKDOWN ---
          final Map<TransactionCategory, double> categoryTotals = {};
          final expenseTxs = transactions.where((t) => t.type == TransactionType.expense).toList();
          final totalExpense = expenseTxs.fold(0.0, (s, t) => s + t.amount);

          final categories = {
            'food': const TransactionCategory(id: 'food', label: 'Makanan', icon: '🍜', color: Color(0xFFF97316)),
            'salary': const TransactionCategory(id: 'salary', label: 'Gaji', icon: '💼', color: Color(0xFF10B981)),
            'trading': const TransactionCategory(id: 'trading', label: 'Investasi', icon: '📈', color: Color(0xFF6366F1)),
            'shopping': const TransactionCategory(id: 'shopping', label: 'Belanja', icon: '🛍️', color: Color(0xFFEC4899)),
            'other': const TransactionCategory(id: 'other', label: 'Lainnya', icon: '✦', color: Color(0xFF94A3B8)),
          };

          for (var tx in expenseTxs) {
            final cat = categories[tx.categoryId] ?? categories['other']!;
            categoryTotals[cat] = (categoryTotals[cat] ?? 0) + tx.amount;
          }

          final Map<TransactionCategory, double> donutData = {};
          if (totalExpense > 0) {
            categoryTotals.forEach((cat, amount) {
              donutData[cat] = (amount / totalExpense) * 100;
            });
          }
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMiniSummary(stats),
                
                const SizedBox(height: 32),
                Text('PERBANDINGAN MINGGUAN (DLM RATUS RIBU)', style: AppTheme.geist(size: 11, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 1.0)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration,
                  child: WeeklyBarChart(
                    income: weeklyIncome,
                    expense: weeklyExpense,
                    incomeColor: Colors.blueAccent,
                    expenseColor: AppTheme.rose,
                    incomeDimColor: Colors.blueAccent.withOpacity(0.05),
                    expenseDimColor: AppTheme.rose.withOpacity(0.05),
                  ),
                ),
                
                const SizedBox(height: 32),
                Text('STRUKTUR PENGELUARAN', style: AppTheme.geist(size: 11, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 1.0)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: totalExpense > 0 
                          ? CategoryDonut(data: donutData)
                          : const Center(child: Text('Belum ada pengeluaran')),
                      ),
                      const SizedBox(height: 24),
                      _buildCategoryList(categoryTotals, totalExpense),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniSummary(Map<String, double> stats) {
    return Row(
      children: [
        _SummaryTile(
          label: 'Pemasukan', 
          value: stats['income'] ?? 0, 
          icon: LucideIcons.arrowUpRight, 
          color: Colors.blueAccent
        ),
        const SizedBox(width: 16),
        _SummaryTile(
          label: 'Pengeluaran', 
          value: stats['expense'] ?? 0, 
          icon: LucideIcons.arrowDownLeft, 
          color: AppTheme.rose
        ),
      ],
    );
  }

  Widget _buildCategoryList(Map<TransactionCategory, double> data, double total) {
    final sortedKeys = data.keys.toList()..sort((a, b) => data[b]!.compareTo(data[a]!));

    return Column(
      children: sortedKeys.map((cat) {
        final amount = data[cat]!;
        final pct = (amount / total) * 100;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: cat.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(cat.icon, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cat.label, style: AppTheme.geist(size: 14, w: FontWeight.w600)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: amount / total,
                      backgroundColor: AppTheme.bgSecondary,
                      color: cat.color,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(Fmt.idr(amount), style: AppTheme.mono(size: 13, w: FontWeight.w600)),
                  Text('${pct.toStringAsFixed(1)}%', style: AppTheme.geist(size: 10, color: AppTheme.textMuted)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;

  const _SummaryTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(label, style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                Fmt.idr(value),
                style: AppTheme.mono(size: 16, w: FontWeight.w700, color: AppTheme.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
