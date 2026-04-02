import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/pages/onboarding/onboarding_page.dart';
import 'package:mobile_spendly/pages/main/main_scaffold.dart';
import 'package:mobile_spendly/pages/transactions/add_transaction_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
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
      },
    );
  }
}
