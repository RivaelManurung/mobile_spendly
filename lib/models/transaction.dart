import 'package:flutter/material.dart';

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
