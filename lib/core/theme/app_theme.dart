import 'package:flutter/material.dart';

class AppColors {
  static const warmIvory = Color(0xFFFBF9F5);
  static const deepInk = Color(0xFF1E242B);
  static const mutedSage = Color(0xFF7A8B7B);
  static const softLavender = Color(0xFF9B8FB1);
  static const subtlePeach = Color(0xFFE89A7D);
  static const lightBorder = Color(0xFFE5E0D8);
  static const cardBg = Color(0xFFFFFFFF);
  static const alertRed = Color(0xFFD9534F);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.warmIvory,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        surface: AppColors.warmIvory,
        primary: AppColors.deepInk,
        secondary: AppColors.mutedSage,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmIvory,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.deepInk,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.deepInk, height: 1.5),
        bodyLarge: TextStyle(color: AppColors.deepInk, height: 1.5),
      ),
    );
  }
}
