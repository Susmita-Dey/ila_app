import 'package:flutter/material.dart';

class AppColors {
  // Stark, Clean Canvas (Like Cal.com or Notion)
  static const Color warmCanvas = Color(0xFFFAFAFA); 
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E5E5);

  // High-Contrast Typography
  static const Color charcoalInk = Color(0xFF111111); // Absolute Onyx
  static const Color mutedText = Color(0xFF737373);

  // The Singular Brand Color: "Ila Rose" (Vibrant, highly saturated pinkish-rose)
  static const Color brandAction = Color(0xFFF43F5E); 
  static const Color brandLight = Color(0xFFFFF1F2); // 10% opacity for selected states

  // Legacy aliases to prevent compile errors during transition
  static const Color warmIvory = warmCanvas;
  static const Color deepInk = charcoalInk;
  static const Color mutedSage = mutedText;
  static const Color lightBorder = cardBorder;
  static const Color cardBg = cardSurface;
  static const Color alertRed = Color(0xFFD9534F);
  static const Color softLavender = brandLight;
  static const Color subtlePeach = brandLight;
  static const Color washedSage = cardBorder; // Fallback
  static const Color sageTint = brandLight;
  static const Color dustyBlush = brandLight;
  static const Color blushTint = brandLight;
  static const Color clayTerracotta = brandAction;
  static const Color clayTint = brandLight;
  static const Color warmOchre = brandLight;
  static const Color ochreTint = brandLight;
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.warmCanvas,
      useMaterial3: true,
      fontFamily: 'Inter', // Premium geometric sans-serif (ensure it's in pubspec if strictly needed, but fallback to system sans-serif like Roboto/SF Pro)
      colorScheme: const ColorScheme.light(
        surface: AppColors.warmCanvas,
        primary: AppColors.charcoalInk,
        secondary: AppColors.brandAction,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmCanvas,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.charcoalInk,
          fontSize: 20,
          fontWeight: FontWeight.w800, // Unapologetically bold
          letterSpacing: -0.5, // Tight kerning
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
        titleLarge: TextStyle(color: AppColors.charcoalInk, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleMedium: TextStyle(color: AppColors.charcoalInk, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        bodyLarge: TextStyle(color: AppColors.charcoalInk, height: 1.5, letterSpacing: -0.2),
        bodyMedium: TextStyle(color: AppColors.charcoalInk, height: 1.5, letterSpacing: -0.2),
        bodySmall: TextStyle(color: AppColors.mutedText, height: 1.5, letterSpacing: -0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandAction,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          iconColor: Colors.white, // Explicitly force white icon on brandAction
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.charcoalInk,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          iconColor: AppColors.charcoalInk,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.warmCanvas,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AppColors.brandAction,
        headerForegroundColor: Colors.white,
        dividerColor: AppColors.cardBorder,
        dayStyle: const TextStyle(color: AppColors.charcoalInk, fontWeight: FontWeight.w500),
        weekdayStyle: const TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.w600),
        yearStyle: const TextStyle(color: AppColors.charcoalInk),
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.brandAction;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.brandAction;
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          if (states.contains(WidgetState.disabled)) return AppColors.mutedText.withValues(alpha: 0.5);
          return AppColors.charcoalInk;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.brandAction;
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.warmCanvas,
        hourMinuteTextColor: AppColors.charcoalInk,
        hourMinuteColor: AppColors.cardSurface,
        dayPeriodTextColor: AppColors.charcoalInk,
        dayPeriodColor: AppColors.cardSurface,
        dialHandColor: AppColors.brandAction,
        dialBackgroundColor: AppColors.cardSurface,
        dialTextColor: AppColors.charcoalInk,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.cardBorder)),
        dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.cardBorder)),
      ),
    );
  }
}
