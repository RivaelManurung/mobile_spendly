import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';

class GoalSettingPage extends StatelessWidget {
  const GoalSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Financial Goals', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildGoalCard(
              title: 'Dana Darurat',
              current: 12000000,
              target: 20000000,
              color: Colors.blueAccent,
              icon: LucideIcons.shield,
            ),
            const SizedBox(height: 24),
            _buildGoalCard(
              title: 'Liburan ke Bali',
              current: 4500000,
              target: 8000000,
              color: AppTheme.gold,
              icon: LucideIcons.palmtree,
            ),
            const SizedBox(height: 24),
            _buildGoalCard(
              title: 'Beli iPhone 16 Pro',
              current: 1500000,
              target: 22000000,
              color: Color(0xFFEC4899),
              icon: LucideIcons.smartphone,
            ),
            const SizedBox(height: 48),
            _buildAddNewGoalButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({required String title, required double current, required double target, required Color color, required IconData icon}) {
    final progress = current / target;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.geist(size: 16, w: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('${(progress * 100).toStringAsFixed(1)}% Tercapai', style: AppTheme.geist(size: 12, color: AppTheme.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Fmt.idrCompact(current), style: AppTheme.mono(size: 13, w: FontWeight.w700)),
              Text(Fmt.idrCompact(target), style: AppTheme.mono(size: 13, color: AppTheme.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.bgSecondary,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewGoalButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, size: 18),
            const SizedBox(width: 12),
            Text('Tambah Target Baru', style: AppTheme.geist(size: 14, w: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
