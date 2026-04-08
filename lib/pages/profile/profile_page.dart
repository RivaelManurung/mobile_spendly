import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        appBar: AppBar(
          title: Text('Profil', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.settings, size: 20),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary stats
                    Row(
                      children: [
                        _StatTile(
                            label: 'TOTAL TRANSAKSI',
                            value: '${state.transactions.length}',
                            icon: LucideIcons.receipt,
                            color: Colors.blueAccent),
                        const SizedBox(width: 16),
                        _StatTile(
                            label: 'SALDO BERSIH',
                            value: Fmt.idr(state.totalBalance),
                            icon: LucideIcons.wallet,
                            color: state.totalBalance >= 0 ? AppTheme.emerald : AppTheme.rose),
                      ],
                    ),
                    const SizedBox(height: 32),

                    _sectionLabel('DATA & LAPORAN'),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _MenuItem(
                        icon: LucideIcons.fileText, 
                        label: 'Export Laporan (PDF/CSV)', 
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menyiapkan laporan PDF...'),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                        }
                      ),
                    ]),

                    const SizedBox(height: 24),
                    _sectionLabel('PERSONALISASI'),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _MenuItem(
                        icon: LucideIcons.target, 
                        label: 'Atur Anggaran (Budget)', 
                        onTap: () => _showBudgetModal(context),
                      ),
                      _MenuItem(
                        icon: LucideIcons.layers, 
                        label: 'Kelola Kategori Kustom', 
                        onTap: () => _showCategoryManager(context),
                      ),
                      _MenuItem(
                        icon: LucideIcons.smartphone, 
                        label: 'Receipt Scanner (Simulasi Scan)', 
                        onTap: () => Navigator.pushNamed(context, '/receipt-scanner'),
                      ),
                      _MenuItem(
                        icon: LucideIcons.barChart, 
                        label: 'Financial Goals', 
                        onTap: () => Navigator.pushNamed(context, '/goal-setting'),
                      ),
                    ]),

                    const SizedBox(height: 24),
                    _sectionLabel('DUKUNGAN'),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _MenuItem(icon: LucideIcons.helpCircle, label: 'Pusat Bantuan', onTap: () {}),
                      _MenuItem(icon: LucideIcons.star, label: 'Beri Penilaian', onTap: () {}),
                    ]),

                    const SizedBox(height: 48),
                    Center(
                      child: Text(
                        'Spendly v1.0.4 PRO',
                        style: AppTheme.geist(size: 11, color: AppTheme.textMuted, spacing: 0.5),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: AppTheme.geist(
          size: 10,
          w: FontWeight.w700,
          color: AppTheme.textMuted,
          spacing: 1.0,
        ),
      );

  void _showBudgetModal(BuildContext context) {
    final state = context.read<AppState>();
    final ctrl = TextEditingController(text: state.monthlyBudget.toStringAsFixed(0));
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: AppTheme.bgPrimary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Atur Anggaran Bulanan', style: AppTheme.geist(size: 20, w: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Batas pengeluaran total Anda setiap bulan.', style: AppTheme.geist(size: 14, color: AppTheme.textMuted)),
              const SizedBox(height: 32),
              
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                inputFormatters: [ThousandSeparatorFormatter()],
                style: AppTheme.mono(size: 24, w: FontWeight.w700),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  labelText: 'Nominal Anggaran',
                  hintText: '0',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final val = double.tryParse(ctrl.text.replaceAll('.', '')) ?? 0;
                    state.setMonthlyBudget(val);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Anggaran bulanan berhasil diperbarui ke ${Fmt.idr(val)}'),
                        backgroundColor: AppTheme.emerald,
                      ),
                    );
                  },
                  child: Text('Simpan Anggaran', style: AppTheme.geist(size: 16, w: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgPrimary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Consumer<AppState>(
              builder: (context, state, _) {
                final categories = state.categories;
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('KELOLA KATEGORI', style: AppTheme.geist(size: 16, w: FontWeight.w700)),
                          IconButton(
                            icon: const Icon(LucideIcons.x, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: categories.isEmpty
                            ? Center(child: Text('Belum ada kategori.', style: AppTheme.geist(size: 14, color: AppTheme.textMuted)))
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final cat = categories[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: AppTheme.cardDecoration,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48, height: 48,
                                          decoration: BoxDecoration(
                                            color: cat.color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(child: Text(cat.icon, style: const TextStyle(fontSize: 24))),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(cat.label, style: AppTheme.geist(size: 15, w: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(LucideIcons.edit2, size: 18, color: AppTheme.primary),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _showCategoryEditorBottomSheet(context, existingCategory: cat);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(LucideIcons.plus, color: Colors.white, size: 20),
                          label: const Text('Tambah Kategori', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Navigator.pop(context);
                            _showCategoryEditorBottomSheet(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          }
        );
      },
    );
  }

  void _showCategoryEditorBottomSheet(BuildContext context, {TransactionCategory? existingCategory}) {
    final bool isEdit = existingCategory != null;
    final catNameCtrl = TextEditingController(text: existingCategory?.label ?? '');
    final emojis = ['🍔', '🍜', '☕', '🚗', '🛒', '🎮', '🏠', '🏥', '💊', '🎓', '✈️', '📱', '👗', '🎁', '💸', '💼', '📈', '✦'];
    String selEmoji = existingCategory?.icon ?? emojis.first;
    Color selColor = existingCategory?.color ?? Colors.blue;
    TransactionType selType = existingCategory?.type ?? TransactionType.expense;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bgPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setStateSheet) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isEdit ? 'EDIT KATEGORI' : 'BUAT KATEGORI KUSTOM', style: AppTheme.geist(size: 16, w: FontWeight.w700)),
                          IconButton(
                            icon: const Icon(LucideIcons.x, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: catNameCtrl,
                        decoration: const InputDecoration(labelText: 'Nama Kategori'),
                      ),
                      const SizedBox(height: 24),
                      
                      Text('Pilih Ikon:', style: AppTheme.geist(size: 12, color: AppTheme.textMuted)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: emojis.map((e) => GestureDetector(
                          onTap: () => setStateSheet(() => selEmoji = e),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selEmoji == e ? selColor.withOpacity(0.2) : AppTheme.bgSecondary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: selEmoji == e ? selColor : Colors.transparent),
                            ),
                            child: Text(e, style: const TextStyle(fontSize: 24)),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 24),
                      
                      Text('Pilih Warna Tema:', style: AppTheme.geist(size: 12, color: AppTheme.textMuted)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.pink, Colors.teal, Colors.indigo
                        ].map((c) => GestureDetector(
                          onTap: () => setStateSheet(() => selColor = c),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(color: selColor == c ? Colors.black : Colors.transparent, width: 3),
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 32),
                      
                      Row(
                        children: [
                          if (isEdit) ...[
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: BorderSide(color: AppTheme.rose),
                                  foregroundColor: AppTheme.rose,
                                ),
                                onPressed: () {
                                  context.read<AppState>().deleteCategory(existingCategory.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kategori dihapus'), backgroundColor: Colors.red));
                                },
                                child: const Text('Hapus'),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                if (catNameCtrl.text.isEmpty) return;
                                final newCat = TransactionCategory(
                                  id: isEdit ? existingCategory.id : DateTime.now().millisecondsSinceEpoch.toString(),
                                  label: catNameCtrl.text,
                                  icon: selEmoji,
                                  color: selColor,
                                  type: selType,
                                );
                                
                                if (isEdit) {
                                  context.read<AppState>().updateCategory(existingCategory.id, newCat);
                                } else {
                                  context.read<AppState>().addCategory(newCat);
                                }
                                
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Kategori ${catNameCtrl.text} berhasil ${isEdit ? 'diperbarui' : 'ditambahkan'}!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: Text(isEdit ? 'Simpan Perubahan' : 'Buat Kategori', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }

  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.textPrimary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 18, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item.label,
                            style: AppTheme.geist(
                                size: 14,
                                w: FontWeight.w600,
                                color: AppTheme.textPrimary)),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.textMuted),
                    ],
                  ),
                ),
              ),
              if (e.key < items.length - 1)
                const Divider(height: 1, indent: 54, color: AppTheme.border),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(label, style: AppTheme.geist(size: 9, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 0.5)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: AppTheme.mono(size: 17, w: FontWeight.w700, color: AppTheme.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
