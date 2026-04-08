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

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Data & Analitik', style: AppTheme.geist(size: 17, w: FontWeight.w700)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          labelStyle: AppTheme.geist(size: 14, w: FontWeight.w700),
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Rincian'),
          ],
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final transactions = state.transactions;
          final stats = state.monthlyStats;
          final income = stats['income'] ?? 0;
          final expense = stats['expense'] ?? 0;
          final savingsRate = income > 0 ? ((income - expense) / income * 100) : 0.0;
          final daysInMonth = DateTime(state.selectedMonth.year, state.selectedMonth.month + 1, 0).day;
          final dailyAvg = expense / daysInMonth;

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Overview
              _buildOverviewTab(state, transactions, stats, savingsRate, dailyAvg),
              // Tab 2: Details
              _buildDetailsTab(state, transactions),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(AppState state, List<Transaction> transactions, Map<String, double> stats, double savingsRate, double dailyAvg) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInsightCards(savingsRate, dailyAvg),
          const SizedBox(height: 32),
          
          _sectionTitle('STRUKTUR PENGELUARAN'),
          const SizedBox(height: 16),
          _buildDonutSection(state, transactions),
          
          const SizedBox(height: 32),
          _sectionTitle('TREN MINGGUAN'),
          const SizedBox(height: 16),
          _buildWeeklyChart(transactions),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(AppState state, List<Transaction> transactions) {
    final expenseTxs = transactions.where((t) => t.type == TransactionType.expense || t.type == TransactionType.goal).toList();
    final totalExpense = expenseTxs.fold(0.0, (s, t) => s + t.amount);
    
    final Map<String, double> categoryLabelTotals = {};
    final Map<String, TransactionCategory> labelToCat = {};

    for (var tx in expenseTxs) {
      if (tx.type == TransactionType.goal) {
        final goal = state.getGoal(tx.categoryId);
        final label = goal?.title ?? 'Tabungan Goal';
        categoryLabelTotals[label] = (categoryLabelTotals[label] ?? 0) + tx.amount;
        if (!labelToCat.containsKey(label)) {
          labelToCat[label] = TransactionCategory(
            id: tx.categoryId,
            label: label,
            icon: goal?.icon ?? '🎯',
            color: goal != null ? Color(int.parse(goal.color)) : Colors.orange,
            type: TransactionType.expense
          );
        }
      } else {
        final cat = state.getCategory(tx.categoryId) ?? const TransactionCategory(
          id: 'other', label: 'Lainnya', icon: '✦', color: Color(0xFF94A3B8), type: TransactionType.expense
        );
        categoryLabelTotals[cat.label] = (categoryLabelTotals[cat.label] ?? 0) + tx.amount;
        labelToCat[cat.label] = cat;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('PERINGKAT PENGELUARAN'),
          const SizedBox(height: 16),
          _buildCategoryRanking(categoryLabelTotals, labelToCat, totalExpense),
        ],
      ),
    );
  }

  Widget _buildInsightCards(double savingsRate, double dailyAvg) {
    return Row(
      children: [
        _InsightCard(
          label: 'Rasio Tabungan',
          value: '${savingsRate.toStringAsFixed(1)}%',
          subLabel: 'dari total gaji',
          icon: LucideIcons.trendingUp,
          color: AppTheme.emerald,
        ),
        const SizedBox(width: 16),
        _InsightCard(
          label: 'Rerata Harian',
          value: Fmt.idrCompact(dailyAvg),
          subLabel: 'pengeluaran',
          icon: LucideIcons.calendar,
          color: Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _buildDonutSection(AppState state, List<Transaction> transactions) {
     final expenseTxs = transactions.where((t) => t.type == TransactionType.expense || t.type == TransactionType.goal).toList();
     final totalExpense = expenseTxs.fold(0.0, (s, t) => s + t.amount);
     
     final Map<TransactionCategory, double> donutData = {};
     for (var tx in expenseTxs) {
       TransactionCategory cat;
       if (tx.type == TransactionType.goal) {
         final goal = state.getGoal(tx.categoryId);
         cat = TransactionCategory(
           id: tx.categoryId,
           label: goal?.title ?? 'Tabungan',
           icon: goal?.icon ?? '🎯',
           color: goal != null ? Color(int.parse(goal.color)) : Colors.orange,
           type: TransactionType.expense
         );
       } else {
         cat = state.getCategory(tx.categoryId) ?? const TransactionCategory(
           id: 'other', label: 'Lainnya', icon: '✦', color: Color(0xFF94A3B8), type: TransactionType.expense
         );
       }
       donutData[cat] = (donutData[cat] ?? 0) + (tx.amount / totalExpense * 100);
     }

     return Container(
       padding: const EdgeInsets.all(24),
       decoration: AppTheme.cardDecoration,
       child: Column(
         children: [
            SizedBox(
              height: 200,
              child: totalExpense > 0 
                ? CategoryDonut(data: donutData)
                : const Center(child: Text('Belum ada data pengeluaran')),
            ),
            if (totalExpense > 0) ...[
              const SizedBox(height: 24),
              Text(
                'Total Pengeluaran: ${Fmt.idr(totalExpense)}',
                style: AppTheme.geist(size: 14, w: FontWeight.w700),
              )
            ]
         ],
       ),
     );
  }

  Widget _buildWeeklyChart(List<Transaction> transactions) {
    final now = DateTime.now();
    final List<double> weeklyIncome = List.filled(7, 0.0);
    final List<double> weeklyExpense = List.filled(7, 0.0);
    
    for (int i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: 6 - i));
        weeklyIncome[i] = transactions
            .where((t) => isSameDay(t.date, day) && t.type == TransactionType.income)
            .fold(0.0, (s, t) => s + t.amount) / 100000;
        weeklyExpense[i] = transactions
            .where((t) => isSameDay(t.date, day) && (t.type == TransactionType.expense || t.type == TransactionType.goal))
            .fold(0.0, (s, t) => s + t.amount) / 100000;
    }

    return Container(
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
    );
  }

  Widget _buildCategoryRanking(Map<String, double> data, Map<String, TransactionCategory> labelToCat, double total) {
    final sortedLabels = data.keys.toList()..sort((a, b) => data[b]!.compareTo(data[a]!));
    if (sortedLabels.isEmpty) return const Center(child: Text('Tidak ada rincian data.'));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: sortedLabels.map((label) {
          final cat = labelToCat[label]!;
          final amt = data[label]!;
          final pct = amt / total;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: (cat.color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(cat.icon, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cat.label, style: AppTheme.geist(size: 15, w: FontWeight.w600)),
                          Text(Fmt.idr(amt), style: AppTheme.mono(size: 13, w: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: AppTheme.bgSecondary,
                          color: cat.color,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${(pct * 100).toStringAsFixed(1)}% dari total pengeluaran', style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTheme.geist(size: 11, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.2));
  }
}

class _InsightCard extends StatelessWidget {
  final String label;
  final String value;
  final String subLabel;
  final IconData icon;
  final Color color;

  const _InsightCard({required this.label, required this.value, required this.subLabel, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 16),
            Text(value, style: AppTheme.geist(size: 22, w: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(label, style: AppTheme.geist(size: 12, w: FontWeight.w600)),
            Text(subLabel, style: AppTheme.geist(size: 10, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}
