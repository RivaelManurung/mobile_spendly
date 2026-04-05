import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionCategory {
  final String id, label, icon;
  final Color color;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
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
    required this.id,
    required this.title,
    this.note,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'notes': note,
      'amount': amount,
      'type': type == TransactionType.income ? 'Income' : 'Expense',
      'categoryId': categoryId,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      note: map['notes'],
      amount: map['amount'] ?? 0.0,
      type: map['type'] == 'Income'
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: map['categoryId'],
      date: DateTime.parse(map['date']),
    );
  }
}
