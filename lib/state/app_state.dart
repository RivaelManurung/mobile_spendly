import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/models/financial_goal.dart';
import 'package:mobile_spendly/models/goal_contribution.dart';
import 'package:mobile_spendly/services/ai_service.dart';
import 'package:mobile_spendly/services/sync_service.dart';
import 'package:mobile_spendly/database/app_database.dart' as db;
import 'package:drift/drift.dart' as drift;
import '../database/db_helper.dart';

class AppState extends ChangeNotifier {
  final db.AppDatabase database;
  final SyncService? syncService;
  
  List<Transaction> _transactions = [];
  List<TransactionCategory> _categories = [];
  List<FinancialGoal> _goals = [];
  List<GoalContribution> _contributions = [];
  double _monthlyBudget = 0;
  bool _isLoading = true;
  bool _isAIAnalysing = false;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  
  final AIService _aiService = AIService();

  AppState({required this.database, this.syncService}) {
    loadData();
  }

  String _userName = 'Pengguna';
  String _latestAIInsight = 'Berdasarkan riwayat transaksi Anda, pengeluaran terbesar bulan ini ada di kategori Makanan.';

  List<Transaction> get transactions {
    return _transactions
        .where((t) =>
            t.date.month == _selectedMonth.month &&
            t.date.year == _selectedMonth.year)
        .toList();
  }

  List<Transaction> get allTransactions => _transactions;
  List<TransactionCategory> get categories => _categories;
  List<FinancialGoal> get goals => _goals;
  List<GoalContribution> get contributions => _contributions;
  double get monthlyBudget => _monthlyBudget;

  bool get isLoading => _isLoading;
  bool get isAIAnalysing => _isAIAnalysing;
  String get userName => _userName;
  String get latestAIInsight => _latestAIInsight;
  DateTime get selectedMonth => _selectedMonth;

  void setMonth(DateTime month) { _selectedMonth = DateTime(month.year, month.month); notifyListeners(); }
  void nextMonth() { _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1); notifyListeners(); }
  void previousMonth() { _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1); notifyListeners(); }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final dbHelper = DatabaseHelper.instance;
    final txList = await dbHelper.queryAllRows(DatabaseHelper.tableTransactions);
    final catList = await dbHelper.queryAllRows(DatabaseHelper.tableCategories);
    final goalList = await dbHelper.queryAllRows(DatabaseHelper.tableGoals);
    final budgetList = await dbHelper.queryAllRows(DatabaseHelper.tableBudgets);
    final contribList = await dbHelper.queryAllRows(DatabaseHelper.tableGoalContributions);

    _transactions = txList.map((item) => Transaction.fromMap(item)).toList();
    _transactions.sort((a, b) => b.date.compareTo(a.date));

    _categories = catList.map((item) => TransactionCategory.fromMap(item)).toList();
    
    // Migrasi Kategori ke Drift (Agar sistem Sync punya data kategori)
    for (var cat in _categories) {
      await database.upsertCategory(db.CategoriesCompanion(
        id: drift.Value(cat.id),
        label: drift.Value(cat.label),
        icon: drift.Value(cat.icon),
        color: drift.Value(cat.color.value.toRadixString(16)),
        type: drift.Value(cat.type.toString().split('.').last),
      ));
    }
    
    _goals = goalList.map((item) => FinancialGoal.fromMap(item)).toList();
    _contributions = contribList.map((item) => GoalContribution.fromMap(item)).toList();
    _contributions.sort((a, b) => b.date.compareTo(a.date));

    if (budgetList.isNotEmpty) {
      _monthlyBudget = budgetList[0]['amount'];
    } else {
      _monthlyBudget = 0;
    }

    _isLoading = false;
    notifyListeners();
    refreshAIInsight();
  }

  Future<void> refreshAIInsight({String? userQuestion}) async {
    _isAIAnalysing = true;
    notifyListeners();
    try {
      final insight = await _aiService.getFinancialInsight(transactions: _transactions, goals: _goals, monthlyBudget: _monthlyBudget, userQuestion: userQuestion);
      _latestAIInsight = insight;
    } catch (e) {
      _latestAIInsight = "Gagal memperbarui analisis AI: $e";
    } finally {
      _isAIAnalysing = false;
      notifyListeners();
    }
  }

  // --- TRANSACTIONS ---
  Future<void> addTransaction(Transaction tx) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insert(DatabaseHelper.tableTransactions, tx.toMap());

    // Dual Save to Drift for Sync
    await database.insertDbTransaction(db.TransactionsCompanion(
      id: drift.Value(tx.id),
      title: drift.Value(tx.title),
      amount: drift.Value(tx.amount),
      date: drift.Value(tx.date),
      type: drift.Value(tx.type.toString().split('.').last),
      categoryId: drift.Value(tx.categoryId),
      notes: drift.Value(tx.note ?? ''),
    ));

    syncService?.syncAll();
    await loadData();
  }

  Future<void> updateTransaction(String id, Transaction updated) async {
    await DatabaseHelper.instance.update(DatabaseHelper.tableTransactions, updated.toMap(), id);
    await loadData();
  }

  Future<void> deleteTransaction(String id) async {
    await DatabaseHelper.instance.delete(DatabaseHelper.tableTransactions, id);
    await loadData();
  }

  // --- GOALS ---
  Future<void> addGoal(FinancialGoal goal) async {
    await DatabaseHelper.instance.insert(DatabaseHelper.tableGoals, goal.toMap());
    await loadData();
  }
  Future<void> updateGoal(String id, FinancialGoal goal) async {
    await DatabaseHelper.instance.update(DatabaseHelper.tableGoals, goal.toMap(), id);
    await loadData();
  }
  Future<void> deleteGoal(String id) async {
    await DatabaseHelper.instance.delete(DatabaseHelper.tableGoals, id);
    await loadData();
  }

  // --- GOAL CONTRIBUTIONS ---
  Future<void> addGoalContribution(GoalContribution contrib) async {
    await DatabaseHelper.instance.insert(DatabaseHelper.tableGoalContributions, contrib.toMap());
    final goalIndex = _goals.indexWhere((g) => g.id == contrib.goalId);
    if (goalIndex != -1) {
      final goal = _goals[goalIndex];
      final updatedGoal = FinancialGoal(id: goal.id, title: goal.title, targetAmount: goal.targetAmount, currentAmount: goal.currentAmount + contrib.amount, color: goal.color, icon: goal.icon, deadline: goal.deadline);
      await DatabaseHelper.instance.update(DatabaseHelper.tableGoals, updatedGoal.toMap(), goal.id);
    }
    await loadData();
  }
  List<GoalContribution> getGoalContributionsByGoal(String goalId) => _contributions.where((c) => c.goalId == goalId).toList();

  // --- CATEGORIES ---
  Future<void> addCategory(TransactionCategory cat) async {
    await DatabaseHelper.instance.insert(DatabaseHelper.tableCategories, cat.toMap());
    await loadData();
  }
  Future<void> updateCategory(String id, TransactionCategory updated) async {
    await DatabaseHelper.instance.update(DatabaseHelper.tableCategories, updated.toMap(), id);
    await loadData();
  }
  Future<void> deleteCategory(String id) async {
    await DatabaseHelper.instance.delete(DatabaseHelper.tableCategories, id);
    await loadData();
  }

  // --- BUDGET ---
  Future<void> setMonthlyBudget(double amount) async {
    final buds = await DatabaseHelper.instance.queryAllRows(DatabaseHelper.tableBudgets);
    if (buds.isEmpty) {
      await DatabaseHelper.instance.insert(DatabaseHelper.tableBudgets, {'id': 'main_budget', 'categoryId': 'total', 'amount': amount, 'period': 'monthly'});
    } else {
      await DatabaseHelper.instance.update(DatabaseHelper.tableBudgets, {'amount': amount}, buds[0]['id']);
    }
    await loadData();
  }

  TransactionCategory? getCategory(String id) { try { return _categories.firstWhere((c) => c.id == id); } catch (_) { return null; } }
  FinancialGoal? getGoal(String id) { try { return _goals.firstWhere((g) => g.id == id); } catch (_) { return null; } }
  double get totalBalance { return _transactions.fold(0, (sum, t) => t.type == TransactionType.income ? sum + t.amount : sum - t.amount); }
  Map<String, double> get monthlyStats {
    final inc = transactions.where((t) => t.type == TransactionType.income).fold(0.0, (s, t) => s + t.amount);
    final exp = transactions.where((t) => t.type == TransactionType.expense || t.type == TransactionType.goal).fold(0.0, (s, t) => s + t.amount);
    return {'income': inc, 'expense': exp, 'net': inc - exp};
  }
}
