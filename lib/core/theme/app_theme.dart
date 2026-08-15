import 'package:flutter/material.dart';

class AppColors {
  // Canvas & Surfaces
  static const Color warmCanvas = Color(0xFFFAF8F5); // Warm Cream / Ivory
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFEAE4DC);

  // Typography & Primary Strokes
  static const Color charcoalInk = Color(0xFF1E242B);
  static const Color mutedText = Color(0xFF6B7280);

  // Editorial Accent Washes (20% Opacity for Watercolor Fills)
  static const Color washedSage = Color(0xFF8A9A86);
  static const Color sageTint = Color(0x338A9A86); // 20% opacity

  static const Color dustyBlush = Color(0xFFDCAE9F);
  static const Color blushTint = Color(0x33DCAE9F); // 20% opacity

  static const Color clayTerracotta = Color(0xFFD98A72);
  static const Color clayTint = Color(0x33D98A72); // 20% opacity

  static const Color warmOchre = Color(0xFFE8C58C);
  static const Color ochreTint = Color(0x33E8C58C); // 20% opacity
  
  // Legacy aliases to prevent compile errors during transition
  static const Color warmIvory = warmCanvas;
  static const Color deepInk = charcoalInk;
  static const Color mutedSage = washedSage;
  static const Color lightBorder = cardBorder;
  static const Color cardBg = cardSurface;
  static const Color alertRed = Color(0xFFD9534F);
  static const Color softLavender = Color(0xFF9B8FB1);
  static const Color subtlePeach = Color(0xFFE89A7D);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.warmCanvas,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        surface: AppColors.warmCanvas,
        primary: AppColors.charcoalInk,
        secondary: AppColors.washedSage,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmCanvas,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.charcoalInk,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.charcoalInk, height: 1.5),
        bodyLarge: TextStyle(color: AppColors.charcoalInk, height: 1.5),
      ),
    );
  }
}
