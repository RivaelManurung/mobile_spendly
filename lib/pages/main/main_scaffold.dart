import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/services/sync_service.dart';
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

  @override
  void initState() {
    super.initState();
    // Sinkronisasi otomatis setiap kali aplikasi dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SyncService>().syncAll();
    });
  }

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
        backgroundColor: AppTheme.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
