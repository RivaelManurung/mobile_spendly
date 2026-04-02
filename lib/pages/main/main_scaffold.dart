import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/pages/dashboard/dashboard_page.dart';
import 'package:mobile_spendly/pages/analytics/statistics_page.dart';
import 'package:mobile_spendly/pages/profile/profile_page.dart';
import 'package:mobile_spendly/pages/ai_analysis/ai_analysis_page.dart';
import 'package:mobile_spendly/widgets/shared/bottom_nav.dart';
import 'package:mobile_spendly/utils/app_theme.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _pages = const [
    DashboardPage(),
    StatisticsPage(), 
    AIAnalysisPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SpendlyBottomNav(
        activeIndex: _currentIndex,
        onTabChange: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-transaction'),
        backgroundColor: AppTheme.gold,
        child: const Icon(LucideIcons.plus, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
