import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/pages/transactions/edit_transaction_page.dart';

class TransactionDetailPage extends StatelessWidget {
  final Transaction tx;
  const TransactionDetailPage({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final isIncome = tx.type == TransactionType.income;
        final isGoal = tx.type == TransactionType.goal;
        
        String catLabel = 'Umum';
        String catIcon = '📦';
        Color catColor = AppTheme.textMuted;

        if (isGoal) {
          final goal = state.getGoal(tx.categoryId);
          catLabel = goal?.title ?? 'Financial Goal';
          catIcon = goal?.icon ?? '🎯';
          catColor = goal != null ? Color(int.parse(goal.color)) : AppTheme.textMuted;
        } else {
          final cat = state.getCategory(tx.categoryId);
          catLabel = cat?.label ?? 'Umum';
          catIcon = cat?.icon ?? '📦';
          catColor = cat?.color ?? AppTheme.textMuted;
        }

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          appBar: AppBar(
            backgroundColor: AppTheme.bgPrimary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Detail Transaksi', style: AppTheme.geist(size: 16, w: FontWeight.w700)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 20, color: AppTheme.rose),
                onPressed: () => _confirmDelete(context, state),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Hero Header
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppTheme.border.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(catIcon, style: const TextStyle(fontSize: 32)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        catLabel.toUpperCase(),
                        style: AppTheme.geist(size: 10, w: FontWeight.w800, color: AppTheme.textMuted, spacing: 2.0),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tx.title,
                        style: AppTheme.geist(size: 18, w: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${isIncome ? '+' : '-'} ${Fmt.idr(tx.amount)}',
                        style: AppTheme.geist(
                          size: 36, 
                          w: FontWeight.w800, 
                          color: isIncome ? Colors.blueAccent : AppTheme.rose
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INFORMASI TRANSAKSI', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.0)),
                      const SizedBox(height: 24),
                      
                      _InfoRow(icon: LucideIcons.calendar, label: 'Tanggal', value: Fmt.date(tx.date)),
                      _InfoRow(icon: LucideIcons.tag, label: 'Kategori', value: isGoal ? 'Tabungan Goal' : catLabel),
                      _InfoRow(icon: LucideIcons.creditCard, label: 'Metode Pembayaran', value: 'Dompet Utama'),
                      if (tx.note != null && tx.note!.isNotEmpty)
                        _InfoRow(icon: LucideIcons.fileText, label: 'Catatan', value: tx.note!),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Edit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditTransactionPage(tx: tx)),
                        );
                      },
                      child: Text('Edit Transaksi', style: AppTheme.geist(color: Colors.white, w: FontWeight.w600, size: 15)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hapus Transaksi?',
                style: AppTheme.geist(size: 18, w: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                'Tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: AppTheme.geist(size: 14, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Batal',
                        style: AppTheme.geist(size: 14, w: FontWeight.w600, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      state.deleteTransaction(tx.id);
                      Navigator.pop(context); // Dialog
                      Navigator.pop(context); // Detail Page
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Hapus',
                        style: AppTheme.geist(size: 14, w: FontWeight.w600, color: AppTheme.rose),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bgSecondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 20, color: AppTheme.textPrimary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.geist(size: 11, color: AppTheme.textMuted, w: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: AppTheme.geist(size: 15, w: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
