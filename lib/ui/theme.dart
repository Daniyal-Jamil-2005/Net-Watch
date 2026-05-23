import 'package:flutter/material.dart';

class AppTheme {
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: blue500,
      scaffoldBackgroundColor: slate50,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: slate900,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: blue600,
        unselectedItemColor: slate400,
      ),
      fontFamily: 'Inter', // Assuming standard modern sans-serif
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: blue500,
      scaffoldBackgroundColor: slate950,
      cardColor: slate800.withOpacity(0.5),
      appBarTheme: AppBarTheme(
        backgroundColor: slate900.withOpacity(0.8),
        foregroundColor: slate50,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: slate900.withOpacity(0.9),
        selectedItemColor: blue400,
        unselectedItemColor: slate500,
      ),
      fontFamily: 'Inter',
    );
  }
}
