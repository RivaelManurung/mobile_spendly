import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palet Warna Modern SaaS (Clean & Professional)
  static const Color bgPrimary = Color(0xFFF1F5F9); // Lighter background
  static const Color bgSecondary = Color(0xFFE2E8F0);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgAI = Color(0xFFF8FAFC);
  
  static const Color blue = Color(0xFF2563EB); // Modern SaaS Blue
  static const Color blueDim = Color(0x152563EB);
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldDim = Color(0x1510B981);
  static const Color rose = Color(0xFFEF4444);
  static const Color roseDim = Color(0x15EF4444);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color violetDim = Color(0x158B5CF6);
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);

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
    primaryColor: blue,
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
      surface: bgPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgPrimary,
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
      backgroundColor: Colors.white,
      elevation: 8,
    ),
  );

  // Backward compatibility aliases
  static const Color primary = blue;
  static const Color primaryLight = Color(0xFF60A5FA); 
  static const Color gold = blue; // Fallback
  static const Color goldLight = Color(0xFF60A5FA); // Fallback
  static const Color goldDim = blueDim; // Fallback
  static const Color bg = bgPrimary;
  static const Color income = emerald;
  static const Color expense = rose;
  static const Color surface = bgCard;
  static const Color textHint = textMuted; 

  static TextStyle get fontMono => GoogleFonts.robotoMono(fontWeight: FontWeight.w600);
  static TextStyle get fontDisplay => GoogleFonts.inter(fontWeight: FontWeight.w700);

  static BoxDecoration get card => BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
