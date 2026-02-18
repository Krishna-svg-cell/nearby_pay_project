import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0D1117);
  static const cardBg = Color(0xFF161B22);
  static const border = Color(0xFF30363D);
  static const textPrimary = Color(0xFFC9D1D9);
  static const textSecondary = Color(0xFF8B949E);
  
  static const greenAccent = Color(0xFF30C079);
  static const blueAccent = Color(0xFF2594D0);
  
  static const gradientPrimary = LinearGradient(
    colors: [greenAccent, blueAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}