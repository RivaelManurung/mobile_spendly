---
description: "Step 1 — Sistem Desain & Utilitas Flutter (Tema, Mata Uang, Tanggal)"
---

# 🎨 STEP 1 — Design System & Helpers

Bentuk estetika aplikasi "Dark Luxury" dengan mendefinisikan sistem desain (warna, font) dan utilitas pembantu.

## 1a. `lib/utils/app_theme.dart` (Luxury Dark Theme)
Salin sistem desain berikut untuk mendapatkan palet warna premium (Gold & Deep Black).

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palet Warna Premium
  static const Color bgPrimary = Color(0xFF08080F);
  static const Color bgSecondary = Color(0xFF0F0F1A);
  static const Color bgCard = Color(0xFF14141F);
  
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C97A);
  static const Color emerald = Color(0xFF10B981);
  static const Color rose = Color(0xFFF43F5E);
  
  static const Color textPrimary = Color(0xFFF0F0F8);
  static const Color textSecondary = Color(0xFFA0A0B8);
  static const Color textMuted = Color(0xFF606078);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgPrimary,
    primaryColor: gold,
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    cardTheme: CardTheme(
      color: bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static TextStyle get fontDisplay => GoogleFonts.playfairDisplay(
    fontWeight: FontWeight.w700,
  );

  static TextStyle get fontMono => GoogleFonts.jetbrainsMono(
    fontWeight: FontWeight.w600,
  );
}
```

## 1b. `lib/utils/formatters.dart` (Currency & Date)
Helper untuk memformat mata uang (IDR) dan tanggal bahasa Indonesia.

```dart
import 'package:intl/intl.dart';

class Fmt {
  static String idr(double val) => NumberFormat.currency(
    locale: 'id_ID', 
    symbol: 'Rp ', 
    decimalDigits: 0
  ).format(val);

  static String date(DateTime d) => DateFormat('dd MMM yyyy', 'id_ID').format(d);
  
  static String monthYear(DateTime d) => DateFormat('MMMM yyyy', 'id_ID').format(d);
  
  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 18) return 'Selamat sore';
    return 'Selamat malam';
  }
}
```
