import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AIAnalysisPage extends StatelessWidget {
  const AIAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('AI Financial Insight', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // AI Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.sparkles, size: 32, color: Colors.blueAccent),
                ),
                const SizedBox(height: 24),
                Text(
                  'Analisis AI Berjalan',
                  style: AppTheme.geist(size: 18, w: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kami menyesuaikan insight berdasarkan transaksi terbaru Anda.',
                  textAlign: TextAlign.center,
                  style: AppTheme.geist(size: 12, color: AppTheme.textMuted),
                ),
                
                const SizedBox(height: 32),
                _buildAnalysisCard(state.latestAIInsight),
                
                const SizedBox(height: 24),
                _buildTipTile(
                  icon: LucideIcons.lightbulb,
                  title: 'Aturan 50/30/20',
                  desc: 'Gunakan aturan ini untuk mengelola anggaran bulan depan agar lebih stabil.',
                  color: AppTheme.gold,
                ),
                const SizedBox(height: 16),
                _buildTipTile(
                  icon: LucideIcons.trendingUp,
                  title: 'Potensi Investasi',
                  desc: 'Anda memiliki sisa saldo yang cukup untuk mulai menabung di instrumen Reksadana.',
                  color: AppTheme.emerald,
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalysisCard(String insight) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.messageSquare, size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 8),
              Text('REKOMENDASI PERSONAL', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.0)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            insight,
            style: AppTheme.geist(size: 14, color: AppTheme.textPrimary, height: 1.6, w: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTipTile({required IconData icon, required String title, required String desc, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.geist(size: 14, w: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(desc, style: AppTheme.geist(size: 12, color: AppTheme.textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
