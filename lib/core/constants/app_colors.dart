import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color brand = Color(0xFFE86A33);
  static const Color brandDark = Color(0xFFC4531E);
  static const Color brandLight = Color(0xFFFF8C5A);

  static const Color background = Color(0xFFF8F4F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color divider = Color(0xFFE5E5E5);

  static const List<Color> driverColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFF9C27B0), // Purple
    Color(0xFFFF9800), // Amber
    Color(0xFF00BCD4), // Cyan
    Color(0xFFE91E63), // Pink
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  static Color driverColor(int index) =>
      driverColors[index % driverColors.length];
}
