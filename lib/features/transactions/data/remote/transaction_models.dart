class CreateTransactionRequest {
  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final String type;
  final String note;
  final bool isRecurring;
  final DateTime date;

  CreateTransactionRequest({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.type,
    required this.note,
    required this.isRecurring,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category_id': categoryId,
    'type': type,
    'note': note,
    'is_recurring': isRecurring,
    'date': date.toIso8601String(),
  };
}

class TransactionResponse {
  final String id;
  final String? status;

  TransactionResponse({required this.id, this.status});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      id: json['id'] ?? '',
      status: json['status'],
    );
  }
}
