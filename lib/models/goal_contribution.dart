class GoalContribution {
  final String id;
  final String goalId;
  final double amount;
  final DateTime date;
  final String? note;

  GoalContribution({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalId': goalId,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory GoalContribution.fromMap(Map<String, dynamic> map) {
    return GoalContribution(
      id: map['id'],
      goalId: map['goalId'],
      amount: map['amount'] as double,
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}
