import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  // Define the raw Hex Colors
  static const Color primaryBlue = Color(0xFF0C66E4);
  static const Color primaryWhite = Colors.white;
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF091E42);
  static const Color textSecondary = Color(0xFF44546F);
  static const Color textGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color.fromARGB(255, 239, 81, 63);
  static const Color successGreen = Color(0xFF22A06B);
  static const Color borderGrey = Color(0xFFBDBDBD);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,

      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        onPrimary: primaryWhite,
        secondary: borderGrey,
        surfaceBright: successGreen,
        surface: backgroundLight,
        onSurface: textDark,
        onSurfaceVariant: textSecondary,
        surfaceContainerHighest: surfaceGray,

        error: errorRed,
      ),

      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: textDark,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        headlineSmall: TextStyle(
          color: textSecondary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(color: textDark, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(
          fontSize: 14,
          color: textDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),

        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(
          color: textDark,
          fontWeight: FontWeight.w500,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),

        errorStyle: const TextStyle(color: errorRed, fontSize: 12),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: primaryWhite,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
