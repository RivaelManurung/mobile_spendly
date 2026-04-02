---
description: "Step 6 — Manajemen Transaksi & Statistik Kategori Flutter"
---

# 💸 STEP 6 — Transactions & Stats (Part 2)

Lengkapi fitur utama aplikasi dengan sistem pencatatan transaksi dan analisis statistik pengeluaran per kategori.

## 6a. `lib/pages/transactions/add_transaction_page.dart`
Formulir input untuk memasukkan transaksi baru dengan pemilihan kategori dan tipe (Masuk/Keluar).

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../state/app_state.dart';
import '../../utils/theme.dart';
import '../../widgets/shared/category_chip.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  TransactionCategory? _selectedCategory;
  TransactionType _selectedType = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi Baru')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildTypeSelector(),
              _buildAmountField(),
              _buildTitleField(),
              _buildCategorySelector(),
              const SizedBox(height: 40),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _typeItem('Pemasukan', TransactionType.income, AppTheme.emerald),
        const SizedBox(width: 20),
        _typeItem('Pengeluaran', TransactionType.expense, AppTheme.rose),
      ],
    );
  }

  Widget _typeItem(String label, TransactionType type, Color color) {
    final isActive = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (val) => setState(() => _selectedType = type),
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: isActive ? color : AppTheme.textMuted),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(labelText: 'Jumlah (Rp)', labelStyle: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(labelText: 'Keterangan (e.g. Makan malam)'),
    );
  }

  Widget _buildCategorySelector() {
    // Tampilkan List Kategori Disini
    return const SizedBox.shrink(); 
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final tx = Transaction(
            id: DateTime.now().toString(),
            title: _titleController.text,
            amount: double.parse(_amountController.text),
            type: _selectedType,
            categoryId: _selectedCategory?.id ?? 'other',
            date: DateTime.now(),
          );
          context.read<AppState>().addTransaction(tx);
          Navigator.pop(context);
        }
      },
      child: const Text('Simpan Transaksi'),
    );
  }
}
```

## 6b. `lib/pages/statistics_page.dart`
Halaman analitik yang menampilkan visualisasi pengeluaran bulanan menggunakan grafik Donut.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/charts/category_donut.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Keuangan')),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          // Hitung Breakdown Kategori Disini
          final Map<TransactionCategory, double> data = {}; 
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CategoryDonut(data: data),
                const SizedBox(height: 40),
                _buildCategoryList(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryList(Map<TransactionCategory, double> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final cat = data.keys.elementAt(index);
        return ListTile(
          leading: Text(cat.icon, style: const TextStyle(fontSize: 24)),
          title: Text(cat.label),
          trailing: Text('${data[cat]!.toStringAsFixed(0)}%'),
        );
      },
    );
  }
}
```
