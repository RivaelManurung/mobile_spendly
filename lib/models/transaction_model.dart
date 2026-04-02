import 'package:flutter/material.dart';

enum TransactionType { income, expense }

enum TransactionCategory {
  // Income
  gaji,
  bisnis,
  investasi,
  hadiah,
  lainnyaPemasukan,
  // Expense
  makanan,
  transportasi,
  belanja,
  tagihan,
  hiburan,
  kesehatan,
  pendidikan,
  tabungan,
  lainnyaPengeluaran,
}

extension TransactionCategoryExt on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.gaji: return 'Gaji';
      case TransactionCategory.bisnis: return 'Bisnis';
      case TransactionCategory.investasi: return 'Investasi';
      case TransactionCategory.hadiah: return 'Hadiah';
      case TransactionCategory.lainnyaPemasukan: return 'Lainnya';
      case TransactionCategory.makanan: return 'Makanan';
      case TransactionCategory.transportasi: return 'Transportasi';
      case TransactionCategory.belanja: return 'Belanja';
      case TransactionCategory.tagihan: return 'Tagihan';
      case TransactionCategory.hiburan: return 'Hiburan';
      case TransactionCategory.kesehatan: return 'Kesehatan';
      case TransactionCategory.pendidikan: return 'Pendidikan';
      case TransactionCategory.tabungan: return 'Tabungan';
      case TransactionCategory.lainnyaPengeluaran: return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.gaji: return Icons.work_rounded;
      case TransactionCategory.bisnis: return Icons.business_center_rounded;
      case TransactionCategory.investasi: return Icons.trending_up_rounded;
      case TransactionCategory.hadiah: return Icons.card_giftcard_rounded;
      case TransactionCategory.lainnyaPemasukan: return Icons.add_circle_outline;
      case TransactionCategory.makanan: return Icons.restaurant_rounded;
      case TransactionCategory.transportasi: return Icons.directions_car_rounded;
      case TransactionCategory.belanja: return Icons.shopping_bag_rounded;
      case TransactionCategory.tagihan: return Icons.receipt_long_rounded;
      case TransactionCategory.hiburan: return Icons.movie_rounded;
      case TransactionCategory.kesehatan: return Icons.local_hospital_rounded;
      case TransactionCategory.pendidikan: return Icons.school_rounded;
      case TransactionCategory.tabungan: return Icons.savings_rounded;
      case TransactionCategory.lainnyaPengeluaran: return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TransactionCategory.gaji: return const Color(0xFF2196F3);
      case TransactionCategory.bisnis: return const Color(0xFF9C27B0);
      case TransactionCategory.investasi: return const Color(0xFF00BCD4);
      case TransactionCategory.hadiah: return const Color(0xFFFF9800);
      case TransactionCategory.lainnyaPemasukan: return const Color(0xFF607D8B);
      case TransactionCategory.makanan: return const Color(0xFFFF5722);
      case TransactionCategory.transportasi: return const Color(0xFF3F51B5);
      case TransactionCategory.belanja: return const Color(0xFFE91E63);
      case TransactionCategory.tagihan: return const Color(0xFF795548);
      case TransactionCategory.hiburan: return const Color(0xFF673AB7);
      case TransactionCategory.kesehatan: return const Color(0xFF4CAF50);
      case TransactionCategory.pendidikan: return const Color(0xFF009688);
      case TransactionCategory.tabungan: return const Color(0xFF1D9E75);
      case TransactionCategory.lainnyaPengeluaran: return const Color(0xFF9E9E9E);
    }
  }

  Color get bgColor => color.withOpacity(0.12);

  TransactionType get type {
    switch (this) {
      case TransactionCategory.gaji:
      case TransactionCategory.bisnis:
      case TransactionCategory.investasi:
      case TransactionCategory.hadiah:
      case TransactionCategory.lainnyaPemasukan:
        return TransactionType.income;
      default:
        return TransactionType.expense;
    }
  }

  static List<TransactionCategory> get incomeCategories => [
    TransactionCategory.gaji,
    TransactionCategory.bisnis,
    TransactionCategory.investasi,
    TransactionCategory.hadiah,
    TransactionCategory.lainnyaPemasukan,
  ];

  static List<TransactionCategory> get expenseCategories => [
    TransactionCategory.makanan,
    TransactionCategory.transportasi,
    TransactionCategory.belanja,
    TransactionCategory.tagihan,
    TransactionCategory.hiburan,
    TransactionCategory.kesehatan,
    TransactionCategory.pendidikan,
    TransactionCategory.tabungan,
    TransactionCategory.lainnyaPengeluaran,
  ];
}

class Transaction {
  final String id;
  final String title;
  final String? note;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? paymentMethod;

  Transaction({
    required this.id,
    required this.title,
    this.note,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.paymentMethod,
  });

  Transaction copyWith({
    String? id,
    String? title,
    String? note,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    String? paymentMethod,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
