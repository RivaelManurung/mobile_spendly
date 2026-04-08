import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MonthlyTab extends StatelessWidget {
  final List<Transaction> transactions;
  final Map<String, double> stats;

  const MonthlyTab({super.key, required this.transactions, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildPerformanceCard(),
          const SizedBox(height: 32),
          _buildComparisonSection(),
          const SizedBox(height: 32),
          _buildInsightSection(),
        ]),
      ),
    );
  }

  Widget _buildPerformanceCard() {
    final net = stats['net'] ?? 0;
    final isPos = net >= 0;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            'SALDO BERSIH BULAN INI',
            style: AppTheme.geist(size: 10, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 1.0),
          ),
          const SizedBox(height: 16),
          Text(
            Fmt.idr(net),
            style: AppTheme.geist(size: 28, w: FontWeight.w700, color: isPos ? Colors.blueAccent : AppTheme.rose),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isPos ? Colors.blueAccent : AppTheme.rose).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isPos ? 'Peningkatan dari bulan lalu' : 'Penurunan dari bulan lalu',
              style: AppTheme.geist(size: 11, color: isPos ? Colors.blueAccent : AppTheme.rose, w: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    final income = stats['income'] ?? 0;
    final expense = stats['expense'] ?? 0;
    final total = income + expense;
    final inPct = total > 0 ? (income / total) : 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RASIO PENDAPATAN & PENGELUARAN',
          style: AppTheme.geist(size: 10, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 1.0),
        ),
        const SizedBox(height: 16),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.rose.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: inPct,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _RatioLegend(label: 'Income', pct: inPct * 100, color: Colors.blueAccent),
            _RatioLegend(label: 'Expense', pct: (1 - inPct) * 100, color: AppTheme.rose),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 14, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text('TIP BULANAN', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.primary, spacing: 0.5)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Anda memiliki rasio tabungan sebesar ${(stats['net']! / (stats['income']! > 0 ? stats['income']! : 1) * 100).toStringAsFixed(1)}%. Sangat baik! Pertahankan pola ini.',
            style: AppTheme.geist(size: 13, height: 1.5, color: AppTheme.textPrimary.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

class _RatioLegend extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;
  const _RatioLegend({required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(
          '$label: ${pct.toStringAsFixed(0)}%',
          style: AppTheme.geist(size: 12, color: AppTheme.textMuted, w: FontWeight.w500),
        ),
      ],
    );
  }
}
