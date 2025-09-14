import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = true; // Dark mode first - default to true
  static const String _themeKey = 'isDarkMode';

  bool get isDark => _isDark;

  // Initialize theme from SharedPreferences
  Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? true; // Default to dark mode
    notifyListeners();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);
    notifyListeners();
  }

  // Custom Dark Theme (Commerce-focused)
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00D4AA), // Teal - Shopping/Commerce
        onPrimary: Color(0xFF000000), // Black text on primary
        secondary: Color(0xFFFF6B35), // Orange - Call to action
        onSecondary: Color(0xFFFFFFFF), // White text
        tertiary: Color(0xFF8B5CF6), // Purple - Accent
        onTertiary: Color(0xFFFFFFFF), // White text
        surface: Color(0xFF1A1A1A), // Dark surface
        onSurface: Color(0xFFFFFFFF), // White text
        surfaceContainerHighest: Color(0xFF2A2A2A), // Elevated surface
        onSurfaceVariant: Color(0xFFB3B3B3), // Muted text
        background: Color(0xFF0F0F0F), // Darkest background
        onBackground: Color(0xFFFFFFFF), // White text
        error: Color(0xFFFF5252), // Red
        onError: Color(0xFFFFFFFF), // White text
        outline: Color(0xFF404040), // Border
        shadow: Color(0xFF000000), // Shadow
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2A2A2A),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4AA),
          foregroundColor: const Color(0xFF000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00D4AA), width: 2),
        ),
      ),
    );
  }

  // Custom Light Theme (Commerce-focused)
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00D4AA), // Teal - Shopping/Commerce
        onPrimary: Color(0xFFFFFFFF), // White text on primary
        secondary: Color(0xFFFF6B35), // Orange - Call to action
        onSecondary: Color(0xFFFFFFFF), // White text
        tertiary: Color(0xFF8B5CF6), // Purple - Accent
        onTertiary: Color(0xFFFFFFFF), // White text
        surface: Color(0xFFFFFFFF), // White surface
        onSurface: Color(0xFF000000), // Black text
        surfaceContainerHighest: Color(0xFFF5F5F5), // Light elevated surface
        onSurfaceVariant: Color(0xFF666666), // Muted text
        background: Color(0xFFFAFAFA), // Light background
        onBackground: Color(0xFF000000), // Black text
        error: Color(0xFFD32F2F), // Red
        onError: Color(0xFFFFFFFF), // White text
        outline: Color(0xFFE0E0E0), // Border
        shadow: Color(0xFF000000), // Shadow
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF000000),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4AA),
          foregroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00D4AA), width: 2),
        ),
      ),
    );
  }
}
