import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFFEC4899); // Pink accent
  static const Color accent = Color(0xFF06B6D4); // Cyan

  // Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightChordBadge = Color(0xFFEEF2FF);
  static const Color lightChordText = Color(0xFF4F46E5);

  // Dark Mode
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkChordBadge = Color(0xFF312E81);
  static const Color darkChordText = Color(0xFFA5B4FC);

  // High-Contrast Stage Mode
  // Pitch black OLED, extreme legibility, zero glare for dimly lit stages
  static const Color stageBackground = Color(0xFF000000);
  static const Color stageSurface = Color(0xFF111111);
  static const Color stageTextPrimary = Color(0xFFFFFFFF);
  static const Color stageTextSecondary = Color(0xFFBBBBBB);
  static const Color stageBorder = Color(0xFF333333);
  static const Color stageChord =
      Color(0xFF00FFA3); // Neon Mint Green for Chords
  static const Color stageChordAccent = Color(0xFFFFD600); // Neon Gold
  static const Color stageSectionBadge = Color(0xFFFF007A); // Neon Pink
}
