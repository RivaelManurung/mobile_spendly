import 'package:flutter/material.dart';

enum TransactionType { income, expense, goal }

class TransactionCategory {
  final String id, label, icon;
  final Color color;
  final TransactionType type;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': label,
      'icon': icon,
      'color': '0x${color.value.toRadixString(16).padLeft(8, '0')}',
      'type': type == TransactionType.income 
          ? 'Income' 
          : type == TransactionType.expense ? 'Expense' : 'Goal',
    };
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    String colorString = map['color'] as String;
    int colorInt = int.tryParse(colorString.replaceFirst('0x', ''), radix: 16) ?? 0xFF94A3B8;
    return TransactionCategory(
      id: map['id'],
      label: map['name'],
      icon: map['icon'],
      color: Color(colorInt),
      type: map['type'] == 'Income' 
          ? TransactionType.income 
          : map['type'] == 'Expense' ? TransactionType.expense : TransactionType.goal,
    );
  }
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
      'type': type == TransactionType.income 
          ? 'Income' 
          : type == TransactionType.expense ? 'Expense' : 'Goal',
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
          : map['type'] == 'Expense' ? TransactionType.expense : TransactionType.goal,
      categoryId: map['categoryId'],
      date: DateTime.parse(map['date']),
    );
  }
}
