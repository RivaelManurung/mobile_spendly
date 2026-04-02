import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TransactionDetailPage extends StatelessWidget {
  final Transaction tx;
  const TransactionDetailPage({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == TransactionType.income;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Detail Transaksi', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 20, color: AppTheme.rose),
            onPressed: () {
              // Delete logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Amount header
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.border.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  Text(
                    tx.title,
                    style: AppTheme.geist(size: 14, color: AppTheme.textMuted, w: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${isIncome ? '+' : '-'} ${Fmt.idr(tx.amount)}',
                    style: AppTheme.geist(
                      size: 32, 
                      w: FontWeight.w700, 
                      color: isIncome ? Colors.blueAccent : AppTheme.rose
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Details List
            _buildInfoTile(LucideIcons.calendar, 'Tanggal', Fmt.date(tx.date)),
            _buildInfoTile(LucideIcons.tag, 'Kategori', tx.categoryId.toUpperCase()),
            _buildInfoTile(LucideIcons.wallet, 'Metode', 'Cash / Tunai'),
            _buildInfoTile(LucideIcons.fileText, 'Catatan', tx.note ?? 'Tidak ada catatan'),

            const SizedBox(height: 48),
            
            // Edit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Text('Edit Transaksi', style: AppTheme.geist(color: Colors.white, w: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.bgSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppTheme.textMuted),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
              const SizedBox(height: 2),
              Text(value, style: AppTheme.geist(size: 15, w: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
