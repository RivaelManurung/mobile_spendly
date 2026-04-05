import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';
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
          _buildAssetOverview(),
          const SizedBox(height: 32),
          _buildSpendingBreakdown(),
          const SizedBox(height: 32),
          _buildActionSection(context),
        ]),
      ),
    );
  }

  Widget _buildAssetOverview() {
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
          _AssetItem(label: 'Kas / Tunai', amount: 8450000, color: Colors.blueAccent),
          const Divider(height: 1, indent: 54, color: AppTheme.border),
          _AssetItem(label: 'Bank Utama', amount: 12450000, color: AppTheme.emerald),
          const Divider(height: 1, indent: 54, color: AppTheme.border),
          _AssetItem(label: 'Investasi', amount: 18500000, color: AppTheme.gold),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSpendingBreakdown() {
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
          child: Column(
            children: [
              _CategoryProgress(label: 'Makanan', pct: 0.35, color: Color(0xFFF97316)),
              const SizedBox(height: 16),
              _CategoryProgress(label: 'Belanja', pct: 0.25, color: Color(0xFFEC4899)),
              const SizedBox(height: 16),
              _CategoryProgress(label: 'Transportasi', pct: 0.15, color: Color(0xFF6366F1)),
              const SizedBox(height: 16),
              _CategoryProgress(label: 'Lainnya', pct: 0.25, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ],
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
