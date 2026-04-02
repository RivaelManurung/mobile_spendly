---
description: "Step 7 — Analisis Keuangan AI & Profil Pengguna Flutter"
---

# 🤖 STEP 7 — AI Analyst & Profile

Sentuhan akhir dengan fitur Analisis Keuangan AI yang cerdas dan halaman Profil untuk manajemen data pengguna.

## 7a. `lib/pages/ai_analysis_page.dart`
Halaman yang menghubungkan data transaksi dengan API AI (misalnya Claude/Gemini) untuk memberikan saran keuangan.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../state/app_state.dart';
import '../utils/theme.dart';

class AIAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analisis AI Spendly')),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(LucideIcons.sparkles, size: 48, color: AppTheme.gold),
                const SizedBox(height: 16),
                const Text(
                  'Analisis AI sedang diproses...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildAnalysisCard(),
                _buildTipsSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
      ),
      child: const Text(
"Berdasarkan transaksimu bulan ini, pengeluaran makan di luar naik 15%. Disarankan untuk membatasi frekuensi makan diluar agar tabungan tetap stabil."
      ),
    );
  }

  Widget _buildTipsSection() {
    return const ListTile(
      leading: Icon(LucideIcons.lightbulb, color: AppTheme.gold),
      title: Text('Tips Finansial'),
      subtitle: Text('Gunakan aturan 50/30/20 untuk mengelola gaji bulan depan.'),
    );
  }
}
```

## 7b. `lib/pages/main_scaffold.dart`
Struktur navigasi utama aplikasi yang menggabungkan semua halaman (Pages) dan Bottom Nav.

```dart
import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'statistics_page.dart';
import 'profile_page.dart';
import 'ai_analysis_page.dart';
import '../widgets/shared/bottom_nav.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _pages = [
    const DashboardPage(),
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
```

## 7c. `lib/main.dart`
Titik masuk utama aplikasi yang menghubungkan semua komponen bersama.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'utils/theme.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/main_scaffold.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: SpendlyApp(),
    ),
  );
}

class SpendlyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingPage(),
        '/dashboard': (_) => MainScaffold(),
      },
    );
  }
}
```
