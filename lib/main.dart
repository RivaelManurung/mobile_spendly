import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/pages/onboarding/onboarding_page.dart';
import 'package:mobile_spendly/pages/main/main_scaffold.dart';
import 'package:mobile_spendly/pages/transactions/add_transaction_page.dart';
import 'package:mobile_spendly/pages/tools/receipt_scanner_page.dart';
import 'package:mobile_spendly/pages/tools/goal_setting_page.dart';
import 'package:mobile_spendly/database/app_database.dart';
import 'package:mobile_spendly/services/sync_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Initialize FFI for Windows/Linux/MacOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final database = AppDatabase();
  final syncService = SyncService(database);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(database: database, syncService: syncService),
        ),
        Provider<AppDatabase>.value(value: database),
        Provider<SyncService>.value(value: syncService),
      ],
      child: const SpendlyApp(),
    ),
  );
}

class SpendlyApp extends StatelessWidget {
  const SpendlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/dashboard': (_) => const MainScaffold(),
        '/add-transaction': (_) => const AddTransactionPage(),
        '/receipt-scanner': (_) => const ReceiptScannerPage(),
        '/goal-setting': (_) => const GoalSettingPage(),
      },
    );
  }
}
