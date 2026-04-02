---
description: "Step 3 — Komponen UI Reusable Flutter (Shared Widgets)"
---

# 🎨 STEP 3 — Reusable Widgets

Gunakan komponen UI yang konsisten untuk membangun antarmuka premium di seluruh aplikasi Spendly.

## 3a. `lib/widgets/shared/currency_display.dart`
Komponen untuk menampilkan mata uang dengan format Rupiah yang rapi dan elegan.

```dart
import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/formatters.dart';

class CurrencyDisplay extends StatelessWidget {
  final double amount;
  final bool isNegative;
  final TextStyle? style;

  const CurrencyDisplay({
    required this.amount, this.isNegative = false, this.style
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      Fmt.idr(amount),
      style: style ?? AppTheme.fontMono.copyWith(
        fontSize: 24, 
        color: isNegative ? AppTheme.rose : AppTheme.emerald
      ),
    );
  }
}
```

## 3b. `lib/widgets/shared/category_chip.dart`
Chip kategori yang berwarna dan memiliki ikon representatif untuk navigasi visual yang cepat.

```dart
import 'package:flutter/material.dart';
import '../../models/transaction.dart';

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
```

## 3c. `lib/widgets/shared/bottom_nav.dart`
Navigasi bawah yang elegan dengan desain Glassmorphism dan FAB (Floating Action Button) yang mengapung.

```dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/theme.dart';

class SpendlyBottomNav extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTabChange;

  const SpendlyBottomNav({required this.activeIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.bgSecondary.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(LucideIcons.home, 'Home', 0),
          _navItem(LucideIcons.calendar, 'Kalender', 1),
          const SizedBox(width: 48), // Space for FAB
          _navItem(LucideIcons.barChart, 'Statistik', 2),
          _navItem(LucideIcons.user, 'Profil', 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = activeIndex == index;
    return InkWell(
      onTap: () => onTabChange(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppTheme.gold : AppTheme.textMuted),
          Text(label, style: TextStyle(
            fontSize: 10, 
            color: isActive ? AppTheme.gold : AppTheme.textMuted
          )),
        ],
      ),
    );
  }
}
```
