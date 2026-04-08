import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/models/financial_goal.dart';
import 'package:mobile_spendly/models/goal_contribution.dart';

class GoalDetailPage extends StatelessWidget {
  final FinancialGoal goal;
  const GoalDetailPage({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final contributions = state.getGoalContributionsByGoal(goal.id);
        final progress = goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount) : 0.0;
        final color = Color(int.parse(goal.color));

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          appBar: AppBar(
            title: Text(goal.title, style: AppTheme.geist(size: 17, w: FontWeight.w600)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, color),
                const SizedBox(height: 32),
                _buildProgressCard(context, progress, color),
                const SizedBox(height: 32),
                Text('RIWAYAT TABUNGAN', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.2)),
                const SizedBox(height: 16),
                if (contributions.isEmpty)
                  _buildEmptyHistory()
                else
                  ...contributions.map((c) => _buildContributionItem(c, color)),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(24)),
            child: Center(child: Text(goal.icon, style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(height: 16),
          Text(goal.title, style: AppTheme.geist(size: 24, w: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Target: ${Fmt.idr(goal.targetAmount)}', style: AppTheme.geist(size: 14, color: AppTheme.textMuted, w: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TERKUMPUL', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted)),
                  const SizedBox(height: 4),
                  Text(Fmt.idr(goal.currentAmount), style: AppTheme.mono(size: 18, w: FontWeight.w700)),
                ],
              ),
              Text('${(progress * 100).toStringAsFixed(1)}%', style: AppTheme.geist(size: 22, w: FontWeight.w800, color: color)),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 14,
              backgroundColor: AppTheme.bgSecondary,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(LucideIcons.history, size: 40, color: AppTheme.textMuted.withOpacity(0.3)),
            const SizedBox(height: 12),
            Text('Belum ada riwayat tabungan.', style: AppTheme.geist(size: 14, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionItem(GoalContribution c, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(LucideIcons.arrowUpRight, size: 16, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.note?.isEmpty ?? true ? 'Tambah Tabungan' : c.note!, style: AppTheme.geist(size: 14, w: FontWeight.w600)),
                Text(Fmt.date(c.date), style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Text('+ ${Fmt.idr(c.amount)}', style: AppTheme.mono(size: 14, w: FontWeight.w700, color: AppTheme.emerald)),
        ],
      ),
    );
  }
}
