import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SummaryTab extends StatelessWidget {
  final List<Transaction> transactions;
  const SummaryTab({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildAssetOverview(context),
          const SizedBox(height: 32),
          _buildBudgetProgress(context),
          const SizedBox(height: 32),
          _buildSpendingBreakdown(),
          const SizedBox(height: 32),
          _buildActionSection(context),
        ]),
      ),
    );
  }

  Widget _buildAssetOverview(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final totalBalance = state.totalBalance;
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.bgSecondary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(LucideIcons.landmark, size: 18, color: AppTheme.textMuted),
                    const SizedBox(width: 12),
                    Text('ASET & KEKAYAAN', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.0)),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppTheme.border),
              _AssetItem(label: 'Kas / Tunai', amount: totalBalance * 0.4, color: Colors.blueAccent),
              const Divider(height: 1, indent: 54, color: AppTheme.border),
              _AssetItem(label: 'Bank Utama', amount: totalBalance * 0.6, color: AppTheme.emerald),
              const SizedBox(height: 16),
            ],
          ),
        );
      }
    );
  }

  Widget _buildBudgetProgress(BuildContext context) {
    final state = context.watch<AppState>();
    final totalExpense = state.monthlyStats['expense'] ?? 0;
    final budget = state.monthlyBudget;
    final remaining = budget - totalExpense;
    final progress = budget > 0 ? (totalExpense / budget) : 0.0;
    final bool isOver = totalExpense > budget && budget > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PROGRESS ANGGARAN',
                  style: AppTheme.geist(
                      size: 10,
                      w: FontWeight.w700,
                      color: AppTheme.textMuted,
                      spacing: 1.0)),
              if (budget > 0)
                Text(
                  isOver ? 'Over Budget!' : 'Aman',
                  style: AppTheme.geist(
                      size: 10,
                      w: FontWeight.w700,
                      color: isOver ? AppTheme.rose : AppTheme.emerald),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (budget == 0)
            Center(
                child: Text('Anggaran belum diatur.',
                    style: AppTheme.geist(size: 14, color: AppTheme.textMuted)))
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Fmt.idr(totalExpense),
                        style: AppTheme.mono(size: 18, w: FontWeight.w700)),
                    Text('Terpakai',
                        style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(Fmt.idr(budget),
                        style: AppTheme.mono(size: 18, w: FontWeight.w700, color: AppTheme.primary)),
                    Text('Target Anggaran',
                        style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppTheme.bgSecondary,
                color: isOver ? AppTheme.rose : AppTheme.primary,
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                isOver
                    ? 'Melampaui anggaran ${Fmt.idr(totalExpense - budget)}'
                    : 'Sisa anggaran: ${Fmt.idr(remaining)}',
                style: AppTheme.geist(
                    size: 12,
                    w: FontWeight.w600,
                    color: isOver ? AppTheme.rose : AppTheme.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpendingBreakdown() {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final expenseTxs = transactions.where((t) => t.type == TransactionType.expense).toList();
        final totalExpense = expenseTxs.fold(0.0, (s, t) => s + t.amount);
        
        final Map<String, double> catTotals = {};
        for(var tx in expenseTxs) {
          catTotals[tx.categoryId] = (catTotals[tx.categoryId] ?? 0) + tx.amount;
        }

        final sortedCatIds = catTotals.keys.toList()..sort((a, b) => catTotals[b]!.compareTo(catTotals[a]!));
        final displayCats = sortedCatIds.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DISTRIBUSI PENGELUARAN',
              style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.0),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: totalExpense == 0 
              ? Center(child: Text('Belum ada pengeluaran', style: AppTheme.geist(size: 13, color: AppTheme.textMuted)))
              : Column(
                children: displayCats.map((catId) {
                  final cat = state.getCategory(catId);
                  final amount = catTotals[catId]!;
                  final pct = amount / totalExpense;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CategoryProgress(
                      label: cat?.label ?? 'Lainnya', 
                      pct: pct, 
                      color: cat?.color ?? Colors.grey
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.fileText, size: 18, color: AppTheme.textPrimary),
                const SizedBox(width: 12),
                Text('Download Laporan Bulanan', style: AppTheme.geist(size: 14, w: FontWeight.w600, color: AppTheme.textPrimary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Terakhir diupdate: Hari ini, 10:45',
          style: AppTheme.geist(size: 11, color: AppTheme.textMuted),
        ),
      ],
    );
  }
}

class _AssetItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const _AssetItem({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppTheme.geist(size: 14, w: FontWeight.w500))),
          Text(Fmt.idr(amount), style: AppTheme.mono(size: 13, w: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;
  const _CategoryProgress({required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.geist(size: 13, w: FontWeight.w500)),
            Text('${(pct * 100).toStringAsFixed(0)}%', style: AppTheme.mono(size: 12, color: AppTheme.textMuted)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: pct,
          backgroundColor: AppTheme.bgSecondary,
          color: color,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}
