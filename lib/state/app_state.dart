import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';

class AppState extends ChangeNotifier {
  List<Transaction> _transactions = [
    Transaction(
      id: '1', title: 'Gaji Bulanan', amount: 8500000, 
      type: TransactionType.income, categoryId: 'salary', 
      date: DateTime.now()
    ),
    Transaction(
      id: '2', title: 'Warteg Bahari', amount: 35000, 
      type: TransactionType.expense, categoryId: 'food', 
      date: DateTime.now()
    ),
    Transaction(
      id: '3', title: 'Kopi Kenangan', amount: 15000, 
      type: TransactionType.expense, categoryId: 'food', 
      date: DateTime.now()
    ),
    Transaction(
      id: '4', title: 'Trading Crypto', amount: 953000, 
      type: TransactionType.income, categoryId: 'trading', 
      date: DateTime.now().subtract(const Duration(days: 1))
    ),
    Transaction(
      id: '5', title: 'Makan Malam', amount: 46300, 
      type: TransactionType.expense, categoryId: 'food', 
      date: DateTime.now().subtract(const Duration(days: 1))
    ),
  ];
  String _userName = 'Pengguna';
  String _latestAIInsight = 'Berdasarkan riwayat transaksi Anda, pengeluaran terbesar minggu ini ada di kategori Makanan. Pertimbangkan untuk mengurangi pemesanan online untuk sisa bulan ini.';

  List<Transaction> get transactions => _transactions;
  String get userName => _userName;
  String get latestAIInsight => _latestAIInsight;

  void addTransaction(Transaction tx) {
    _transactions.insert(0, tx);
    notifyListeners();
  }

  void updateTransaction(String id, Transaction updated) {
    final idx = _transactions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _transactions[idx] = updated;
      notifyListeners();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  double get totalBalance {
    return _transactions.fold(0, (sum, t) => 
      t.type == TransactionType.income ? sum + t.amount : sum - t.amount
    );
  }

  Map<String, double> get monthlyStats {
    final now = DateTime.now();
    final thisMonth = _transactions.where((t) => 
      t.date.month == now.month && t.date.year == now.year
    ).toList();
    
    final income = thisMonth.where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final expense = thisMonth.where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
        
    return {'income': income, 'expense': expense, 'net': income - expense};
  }
}
