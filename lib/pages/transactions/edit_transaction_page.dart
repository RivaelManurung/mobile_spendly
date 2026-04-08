import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction tx;
  const EditTransactionPage({super.key, required this.tx});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _noteCtrl;
  
  late TransactionType _type;
  late String _catId;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat.decimalPattern('id_ID');
    _amountCtrl = TextEditingController(text: formatter.format(widget.tx.amount));
    _titleCtrl = TextEditingController(text: widget.tx.title);
    _noteCtrl = TextEditingController(text: widget.tx.note ?? '');
    _type = widget.tx.type;
    _catId = widget.tx.categoryId;
    _date = widget.tx.date;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Edit Transaksi', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
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
              _buildTypeSelector(),
              const SizedBox(height: 32),

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
                        style: AppTheme.geist(size: 42, w: FontWeight.w700, spacing: -1.0),
                        decoration: InputDecoration(
                          hintText: '0',
                          prefixText: 'Rp ',
                          prefixStyle: AppTheme.geist(size: 20, w: FontWeight.w500, color: AppTheme.textMuted),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [ThousandSeparatorFormatter()],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

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
        onTap: () {
          setState(() {
            _type = type;
          });
        },
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
    return Consumer<AppState>(
      builder: (context, state, child) {
        final categories = state.categories;
        if (categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Belum ada kategori.'),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              final isSel = _catId == cat.id;
              return GestureDetector(
                onTap: () => setState(() => _catId = cat.id),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? cat.color.withOpacity(0.1) : AppTheme.bgSecondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? cat.color.withOpacity(0.3) : Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Text(cat.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        cat.label, 
                        style: AppTheme.geist(size: 13, w: isSel ? FontWeight.w600 : FontWeight.w500, color: isSel ? cat.color : AppTheme.textPrimary)
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
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
          if (_amountCtrl.text.isEmpty || _catId.isEmpty) return;
          final updatedTx = Transaction(
            id: widget.tx.id,
            title: _titleCtrl.text.isEmpty ? 'Transaksi Tanpa Nama' : _titleCtrl.text,
            amount: double.parse(_amountCtrl.text.replaceAll('.', '')),
            type: _type,
            categoryId: _catId,
            date: _date,
            note: _noteCtrl.text,
          );
          context.read<AppState>().updateTransaction(widget.tx.id, updatedTx);
          Navigator.pop(context);
        },
        child: Text('Update Transaksi', style: AppTheme.geist(color: Colors.white, size: 16, w: FontWeight.w600)),
      ),
    );
  }
}
