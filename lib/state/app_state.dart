import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';
import '../database/db_helper.dart';

class AppState extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  String _userName = 'Pengguna';
  String _latestAIInsight =
      'Berdasarkan riwayat transaksi Anda, pengeluaran terbesar bulan ini ada di kategori Makanan.';

  List<Transaction> get transactions {
    return _transactions
        .where(
          (t) =>
              t.date.month == _selectedMonth.month &&
              t.date.year == _selectedMonth.year,
        )
        .toList();
  }

  List<Transaction> get allTransactions => _transactions;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get latestAIInsight => _latestAIInsight;
  DateTime get selectedMonth => _selectedMonth;

  void setMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  AppState() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    final dbHelper = DatabaseHelper.instance;
    final dataList = await dbHelper.queryAllRows(
      DatabaseHelper.tableTransactions,
    );

    _transactions = dataList.map((item) => Transaction.fromMap(item)).toList();

    // Sort descending by date
    _transactions.sort((a, b) => b.date.compareTo(a.date));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction tx) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insert(DatabaseHelper.tableTransactions, tx.toMap());
    await loadTransactions();
  }

  Future<void> updateTransaction(String id, Transaction updated) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.update(
      DatabaseHelper.tableTransactions,
      updated.toMap(),
      id,
    );
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.delete(DatabaseHelper.tableTransactions, id);
    await loadTransactions();
  }

  double get totalBalance {
    return _transactions.fold(
      0,
      (sum, t) =>
          t.type == TransactionType.income ? sum + t.amount : sum - t.amount,
    );
  }

  Map<String, double> get monthlyStats {
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final expense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);

    return {'income': income, 'expense': expense, 'net': income - expense};
  }
}
