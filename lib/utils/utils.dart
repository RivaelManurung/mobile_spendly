import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Fmt {
  static final _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String idr(double amount) => _idr.format(amount);

  static String idrCompact(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return idr(amount);
  }

  static String date(DateTime d) => DateFormat('d MMM yyyy', 'id').format(d);
  static String dateShort(DateTime d) => DateFormat('d MMM', 'id').format(d);
  static String dayName(DateTime d) => DateFormat('EEEE', 'id').format(d);
  static String monthYear(DateTime d) => DateFormat('MMMM yyyy', 'id').format(d);
  static String time(DateTime d) => DateFormat('HH:mm').format(d);
  static String weekday(DateTime d) => DateFormat('EEE', 'id').format(d);
}

class AppTheme {
  static const primary = Color(0xFF1A2550);
  static const primaryLight = Color(0xFF2B3FC4);
  static const accent = Color(0xFF5B8EFF);
  static const income = Color(0xFF1D9E75);
  static const expense = Color(0xFFE85D5D);
  static const surface = Colors.white;
  static const bg = Color(0xFFF2F4FB);
  static const textPrimary = Color(0xFF1A2550);
  static const textSecondary = Color(0xFF8899BB);
  static const textHint = Color(0xFFBBCCDD);
  static const cardShadow = Color(0x0A000000);

  static ThemeData get theme => ThemeData(
    fontFamily: 'Nunito',
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLight,
      primary: primaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
    ),
  );

  static BoxDecoration get card => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: cardShadow,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration cardWithBorder(Color borderColor) => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: borderColor.withOpacity(0.3), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: cardShadow,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

String generateId() => DateTime.now().millisecondsSinceEpoch.toString();
