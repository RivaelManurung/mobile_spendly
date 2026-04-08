class FinancialGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String color;
  final String icon;
  final DateTime? deadline;

  FinancialGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.color,
    required this.icon,
    this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'color': color,
      'icon': icon,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory FinancialGoal.fromMap(Map<String, dynamic> map) {
    return FinancialGoal(
      id: map['id'],
      title: map['title'],
      targetAmount: map['targetAmount'],
      currentAmount: map['currentAmount'],
      color: map['color'],
      icon: map['icon'],
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }
}
