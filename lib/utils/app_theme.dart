import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palet Warna Premium (Luxury Dark)
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF8F9FA);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgAI = Color(0xFFF1F5F9);
  
  static const Color gold = Color(0xFFB08900);
  static const Color goldDim = Color(0x15B08900);
  static const Color emerald = Color(0xFF059669);
  static const Color emeraldDim = Color(0x15059669);
  static const Color rose = Color(0xFFE11D48);
  static const Color roseDim = Color(0x15E11D48);
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetDim = Color(0x157C3AED);
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0x1F000000);

  // Typography helpers
  static TextStyle geist({
    double size = 14,
    FontWeight w = FontWeight.w400,
    Color? color,
    double? spacing,
    double? height,
  }) =>
      GoogleFonts.inter(
          fontSize: size,
          fontWeight: w,
          color: color ?? textPrimary,
          letterSpacing: spacing,
          height: height);

  static TextStyle mono({
    double size = 13,
    FontWeight w = FontWeight.w400,
    Color? color,
    double? spacing,
  }) =>
      GoogleFonts.robotoMono(
          fontSize: size, 
          fontWeight: w, 
          color: color ?? textPrimary,
          letterSpacing: spacing);

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgPrimary,
    primaryColor: gold,
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.light,
      surface: bgPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgPrimary.withOpacity(0.8),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: textPrimary),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  // Backward compatibility aliases
  static const Color primary = gold;
  static const Color primaryLight = goldLight; // Added back
  static const Color goldLight = Color(0xFFD4B778); // Needed for alias
  static const Color bg = bgPrimary;
  static const Color income = emerald;
  static const Color expense = rose;
  static const Color surface = bgCard;
  static const Color textHint = textMuted; // Added back

  static TextStyle get fontMono => GoogleFonts.robotoMono(fontWeight: FontWeight.w600);
  static TextStyle get fontDisplay => GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700);

  static BoxDecoration get card => BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: border),
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: border),
  );
}
