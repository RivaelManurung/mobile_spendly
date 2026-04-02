import 'package:flutter/material.dart';
import 'package:mobile_spendly/models/transaction.dart';

class CategoryChip extends StatelessWidget {
  final TransactionCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    required this.category, this.isSelected = false, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? category.color : category.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: category.color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? Colors.white : category.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
