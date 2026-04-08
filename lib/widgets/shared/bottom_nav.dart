import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/utils/app_theme.dart';

class SpendlyBottomNav extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTabChange;

  const SpendlyBottomNav({super.key, required this.activeIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            border: Border(top: BorderSide(color: AppTheme.border.withOpacity(0.08), width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 65, // Increased height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(LucideIcons.home, 'Dashboard', 0),
                  _navItem(LucideIcons.barChart2, 'Statistik', 1),
                  const SizedBox(width: 50), // FAB Space
                  _navItem(LucideIcons.history, 'Riwayat', 2),
                  _navItem(LucideIcons.user, 'Profil', 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChange(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon, 
              size: 22,
              color: isActive ? Colors.blueAccent : AppTheme.textMuted
            ),
            const SizedBox(height: 4),
            Text(
              label, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10, 
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.blueAccent : AppTheme.textMuted
              ),
            ),
          ],
        ),
      ),
    );
  }
}
