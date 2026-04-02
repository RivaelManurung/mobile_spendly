import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  
  TransactionType _type = TransactionType.expense;
  String _catId = 'food';
  DateTime _date = DateTime.now();

  final Map<String, TransactionCategory> _categories = {
    'food': const TransactionCategory(id: 'food', label: 'Makanan', icon: '🍜', color: Color(0xFFF97316)),
    'salary': const TransactionCategory(id: 'salary', label: 'Gaji', icon: '💼', color: Color(0xFF10B981)),
    'trading': const TransactionCategory(id: 'trading', label: 'Investasi', icon: '📈', color: Color(0xFF6366F1)),
    'shopping': const TransactionCategory(id: 'shopping', label: 'Belanja', icon: '🛍️', color: Color(0xFFEC4899)),
    'other': const TransactionCategory(id: 'other', label: 'Lainnya', icon: '✦', color: Color(0xFF94A3B8)),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Tambah Transaksi', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Type Selector
              _buildTypeSelector(),
              const SizedBox(height: 32),

              // Large Amount Input
              Center(
                child: Column(
                  children: [
                    Text('JUMLAH NOMINAL', style: AppTheme.geist(size: 10, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 1.0)),
                    const SizedBox(height: 12),
                    IntrinsicWidth(
                      child: TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        style: AppTheme.geist(size: 42, w: FontWeight.w700, spacing: -1.0),
                        decoration: InputDecoration(
                          hintText: '0',
                          prefixText: 'Rp ',
                          prefixStyle: AppTheme.geist(size: 20, w: FontWeight.w500, color: AppTheme.textMuted),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Form Sections
              _buildFormLabel('KETERANGAN'),
              _buildInputField(
                controller: _titleCtrl,
                hint: 'Nasi Goreng, Gaji, dll...',
                icon: LucideIcons.edit3,
              ),
              
              const SizedBox(height: 24),
              _buildFormLabel('KATEGORI'),
              _buildCategorySelector(),

              const SizedBox(height: 24),
              _buildFormLabel('TANGGAL'),
              _buildDatePicker(),

              const SizedBox(height: 24),
              _buildFormLabel('CATATAN (OPSIONAL)'),
              _buildInputField(
                controller: _noteCtrl,
                hint: 'Tambahkan detail jika perlu...',
                icon: LucideIcons.fileText,
              ),

              const SizedBox(height: 40),
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _typeTab('Pengeluaran', TransactionType.expense, AppTheme.rose),
          _typeTab('Pemasukan', TransactionType.income, Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _typeTab(String label, TransactionType type, Color activeColor) {
    final isActive = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTheme.geist(
                size: 13, 
                w: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? activeColor : AppTheme.textMuted
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(label, style: AppTheme.geist(size: 10, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 1.0)),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String hint, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        style: AppTheme.geist(size: 15, w: FontWeight.w500),
        decoration: InputDecoration(
          icon: Icon(icon, size: 18, color: AppTheme.textMuted),
          hintText: hint,
          hintStyle: AppTheme.geist(size: 15, color: AppTheme.textMuted.withOpacity(0.5)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.entries.map((e) {
          final isSel = _catId == e.key;
          return GestureDetector(
            onTap: () => setState(() => _catId = e.key),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSel ? e.value.color.withOpacity(0.1) : AppTheme.bgSecondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSel ? e.value.color.withOpacity(0.3) : Colors.transparent),
              ),
              child: Row(
                children: [
                  Text(e.value.icon, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    e.value.label, 
                    style: AppTheme.geist(size: 13, w: isSel ? FontWeight.w600 : FontWeight.w500, color: isSel ? e.value.color : AppTheme.textPrimary)
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2030));
        if (d != null) setState(() => _date = d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgSecondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.calendar, size: 18, color: AppTheme.textMuted),
            const SizedBox(width: 16),
            Text(Fmt.date(_date), style: AppTheme.geist(size: 15, w: FontWeight.w500)),
            const Spacer(),
            const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () {
          if (_amountCtrl.text.isEmpty) return;
          final tx = Transaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleCtrl.text.isEmpty ? 'Transaksi Tanpa Nama' : _titleCtrl.text,
            amount: double.parse(_amountCtrl.text),
            type: _type,
            categoryId: _catId,
            date: _date,
            note: _noteCtrl.text,
          );
          context.read<AppState>().addTransaction(tx);
          Navigator.pop(context);
        },
        child: Text('Simpan Transaksi', style: AppTheme.geist(color: Colors.white, size: 16, w: FontWeight.w600)),
      ),
    );
  }
}
