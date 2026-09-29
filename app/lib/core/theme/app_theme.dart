import 'package:flutter/material.dart';
import 'app_colors.dart';

enum AppThemeMode { light, dark, stage }

class AppTheme {
  static const List<String> fontFallbacks = [
    'NotoSansTelugu',
    'sans-serif',
  ];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
    ),
    fontFamilyFallback: fontFallbacks,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 1,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: AppColors.lightBorder, thickness: 1),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: Color(0xFFF87171),
      onPrimary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
    ),
    fontFamilyFallback: fontFallbacks,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 1,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: AppColors.darkBorder, thickness: 1),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
    ),
  );

  /// High-Contrast Stage Mode:
  /// Pure black #000000 background, neon green chords, stark white lyrics, high visibility under stage lights.
  static ThemeData stageTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.stageBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.stageChord,
      secondary: AppColors.stageChordAccent,
      surface: AppColors.stageSurface,
      error: Color(0xFFFF5252),
      onPrimary: Colors.black,
      onSurface: AppColors.stageTextPrimary,
    ),
    fontFamilyFallback: fontFallbacks,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.stageBackground,
      foregroundColor: AppColors.stageTextPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.stageSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.stageBorder, width: 1.5),
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: AppColors.stageBorder, thickness: 1.5),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: AppColors.stageTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: AppColors.stageTextSecondary, fontSize: 15),
    ),
  );
}
