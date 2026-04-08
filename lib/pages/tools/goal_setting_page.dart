import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/models/financial_goal.dart';
import 'package:mobile_spendly/pages/tools/goal_detail_page.dart';

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
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final goals = state.goals;
          
          if (goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.target, size: 64, color: AppTheme.textMuted.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Belum ada target keuangan.', style: AppTheme.geist(size: 14, color: AppTheme.textMuted)),
                  const SizedBox(height: 24),
                  _buildAddNewGoalButton(context),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ...goals.map((goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _GoalCard(goal: goal),
                )),
                const SizedBox(height: 24),
                _buildAddNewGoalButton(context),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddNewGoalButton(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 56,
      child: ElevatedButton.icon(
        icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
        label: Text('Tambah Target', style: AppTheme.geist(size: 14, w: FontWeight.w600, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () => _showAddGoalModal(context),
      ),
    );
  }

  void _showAddGoalModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final emojis = ['🚗', '🏠', '✈️', '💍', '💻', '🎓', '🏥', '🚲', '⌚', '🎁', '📱', '🎮', '💰', '🏗️'];
    String selEmoji = emojis.first;
    Color selColor = Colors.blue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: AppTheme.bgPrimary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tambah Target Baru', style: AppTheme.geist(size: 20, w: FontWeight.w700)),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Label & Unified Input
                  Text('NAMA TARGET', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.2)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: AppTheme.bgSecondary, borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      controller: titleCtrl,
                      style: AppTheme.geist(size: 15, w: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Misal: Beli MacBook Pro',
                        hintStyle: AppTheme.geist(size: 15, color: AppTheme.textMuted),
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text('NOMINAL TARGET', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.2)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: AppTheme.bgSecondary, borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      controller: targetCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandSeparatorFormatter()],
                      style: AppTheme.mono(size: 18, w: FontWeight.w700),
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                        prefixStyle: AppTheme.geist(size: 18, w: FontWeight.w600, color: AppTheme.textMuted),
                        hintText: '0',
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text('PILIH IKON & WARNA', style: AppTheme.geist(size: 10, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.2)),
                  const SizedBox(height: 16),
                  
                  // Emoji Grid
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: emojis.length,
                      itemBuilder: (context, index) {
                        final e = emojis[index];
                        final isSel = selEmoji == e;
                        return GestureDetector(
                          onTap: () => setStateSheet(() => selEmoji = e),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            width: 50,
                            decoration: BoxDecoration(
                              color: isSel ? selColor.withOpacity(0.15) : AppTheme.bgSecondary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? selColor : Colors.transparent, width: 2),
                            ),
                            child: Center(child: Text(e, style: const TextStyle(fontSize: 22))),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  // Color Palette
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Colors.blue, Colors.pinkAccent, Colors.teal, Colors.amber, Colors.purple, Colors.orange
                    ].map((c) {
                      final Color color = c;
                      return GestureDetector(
                        onTap: () => setStateSheet(() => selColor = color),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: selColor == color ? AppTheme.textPrimary : Colors.transparent, width: 3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (titleCtrl.text.isEmpty || targetCtrl.text.isEmpty) return;
                        final amt = double.tryParse(targetCtrl.text.replaceAll('.', '')) ?? 0;
                        context.read<AppState>().addGoal(FinancialGoal(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleCtrl.text,
                          targetAmount: amt,
                          currentAmount: 0,
                          color: '0x${selColor.value.toRadixString(16).toUpperCase()}',
                          icon: selEmoji,
                        ));
                        Navigator.pop(context);
                      },
                      child: Text('Simpan Target', style: AppTheme.geist(size: 16, w: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}


class _GoalCard extends StatelessWidget {
  final FinancialGoal goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount) : 0.0;
    final color = Color(int.parse(goal.color));
    
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetailPage(goal: goal))),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.cardDecoration,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
                  child: Center(
                    child: Text(goal.icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.title, style: AppTheme.geist(size: 16, w: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${(progress * 100).toStringAsFixed(1)}% Terkumpul', style: AppTheme.geist(size: 12, color: AppTheme.textMuted, w: FontWeight.w600)),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, size: 20, color: AppTheme.textMuted),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TERKUMPUL', style: AppTheme.geist(size: 9, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.0)),
                    const SizedBox(height: 4),
                    Text(Fmt.idr(goal.currentAmount), style: AppTheme.mono(size: 14, w: FontWeight.w700)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('TARGET', style: AppTheme.geist(size: 9, w: FontWeight.w700, color: AppTheme.textMuted, spacing: 1.0)),
                    const SizedBox(height: 4),
                    Text(Fmt.idr(goal.targetAmount), style: AppTheme.mono(size: 14, w: FontWeight.w700, color: AppTheme.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppTheme.bgSecondary, borderRadius: BorderRadius.circular(6)),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.7 * progress.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(LucideIcons.trash2, size: 14, color: AppTheme.rose),
                  label: Text('Hapus Target', style: AppTheme.geist(size: 11, color: AppTheme.rose, w: FontWeight.w600)),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Hapus Target?', style: AppTheme.geist(size: 18, w: FontWeight.w700)),
        content: Text('Tindakan ini tidak dapat dibatalkan.', style: AppTheme.geist(size: 14, color: AppTheme.textMuted)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: AppTheme.geist(color: AppTheme.textMuted))),
          TextButton(
            onPressed: () {
              context.read<AppState>().deleteGoal(goal.id);
              Navigator.pop(context);
            }, 
            child: Text('Hapus', style: AppTheme.geist(color: AppTheme.rose, w: FontWeight.w700))
          ),
        ],
      )
    );
  }
}
