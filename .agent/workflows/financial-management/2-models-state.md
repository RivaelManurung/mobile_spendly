---
description: "Step 2 — Model Data & Manajemen State Flutter (Provider)"
---

# 📦 STEP 2 — Models & State Management

Amankan struktur data transaksi dan hubungkan dengan sistem Manajemen State global menggunakan Provider.

## 2a. `lib/models/transaction.dart`
Struktur data utama untuk mencatat pengeluaran dan pemasukan.

```dart
enum TransactionType { income, expense }

class TransactionCategory {
  final String id, label, icon;
  final Color color;

  const TransactionCategory({
    required this.id, required this.label, required this.icon, required this.color
  });
}

class Transaction {
  final String id, title;
  final String? note;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;

  Transaction({
    required this.id, required this.title, this.note, required this.amount,
    required this.type, required this.categoryId, required this.date
  });
}
```

## 2b. `lib/state/app_state.dart` (Provider State)
Manajer state global yang menangani penambahan, pembaruan, dan penghapusan transaksi.

```dart
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AppState extends ChangeNotifier {
  List<Transaction> _transactions = [];
  String _userName = 'Pengguna';

  List<Transaction> get transactions => _transactions;
  String get userName => _userName;

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
```
