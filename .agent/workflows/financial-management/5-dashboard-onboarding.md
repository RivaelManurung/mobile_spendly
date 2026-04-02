---
description: "Step 5 — Antarmuka Onboarding & Dashboard Flutter"
---

# 🏠 STEP 5 — Main Screens (Part 1)

Implementasi dua layar utama aplikasi: Onboarding (untuk menyambut pengguna) dan Dashboard (sebagai pusat kendali keuangan).

## 5a. `lib/pages/onboarding/onboarding_page.dart`
Layar edukasi yang tampil saat pertama kali aplikasi dibuka dengan transisi yang halus.

```dart
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackdrop(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💎', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                'Kendali Penuh Atas Keuanganmu',
                textAlign: TextAlign.center,
                style: AppTheme.fontDisplay.copyWith(fontSize: 32, color: AppTheme.gold),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Catat setiap transaksi, pantau arus kas, dan raih kebebasan finansial dalam satu aplikasi.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Mulai Sekarang', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackdrop() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.bgSecondary, AppTheme.bgPrimary],
        ),
      ),
    );
  }
}
```

## 5b. `lib/pages/dashboard/dashboard_page.dart`
Dashboard yang bersih dan informatif untuk ringkasan saldo, pemasukan, dan grafik mingguan.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../utils/theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/shared/currency_display.dart';
import '../../widgets/charts/weekly_bar_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final stats = state.monthlyStats;
          return CustomScrollView(
            slivers: [
              _buildHeader(state),
              _buildBalanceCard(state, stats),
              _buildWeeklyChartSection(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(Fmt.greeting(), style: const TextStyle(color: AppTheme.textMuted)),
            Text(
              '${state.userName} 👋',
              style: AppTheme.fontDisplay.copyWith(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(AppState state, Map<String, double> stats) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Text('Total Saldo Seluruhnya', style: TextStyle(color: AppTheme.textMuted)),
            CurrencyDisplay(amount: state.totalBalance, style: const TextStyle(fontSize: 36, color: AppTheme.gold)),
            const Divider(color: Colors.white12, height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('Pemasukan', stats['income']!, AppTheme.emerald),
                _statItem('Pengeluaran', stats['expense']!, AppTheme.rose),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        CurrencyDisplay(amount: amount, style: TextStyle(fontSize: 18, color: color)),
      ],
    );
  }

  Widget _buildWeeklyChartSection(AppState state) {
    return const SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: WeeklyBarChart(income: [0, 0, 0, 0, 0, 0, 0], expense: [0, 0, 0, 0, 0, 0, 0]),
      ),
    );
  }
}
```
