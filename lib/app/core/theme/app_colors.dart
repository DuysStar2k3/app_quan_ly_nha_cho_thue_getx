import 'package:flutter/material.dart';

class AppColors {
  // Màu chính
  static const MaterialColor primarySwatch = Colors.blue;
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03A9F4);
  static const Color accent = Color(0xFF00BCD4);

  // Màu nền
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color inputBackground = Color(0xFFF8F9FA);
  static const Color chipBackground = Color(0xFFE0E0E0);

  // Màu văn bản
  static const Color text = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Màu viền
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Màu trạng thái
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Màu cho các trạng thái phòng
  static const Color roomEmpty = Color(0xFF4CAF50);
  static const Color roomOccupied = Color(0xFF2196F3);
  static const Color roomMaintenance = Color(0xFFFF9800);

  // Màu gradient
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF1976D2),
  ];
} 