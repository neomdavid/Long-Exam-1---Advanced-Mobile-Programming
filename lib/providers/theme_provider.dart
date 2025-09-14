import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  // Custom Dark Theme (DaisyUI Dark)
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8B5CF6), // Purple
        onPrimary: Color(0xFFF5F5F5), // Light text
        secondary: Color(0xFFEC4899), // Pink
        onSecondary: Color(0xFFF5F5F5), // Light text
        tertiary: Color(0xFF06B6D4), // Cyan (accent)
        onTertiary: Color(0xFF1A1A1A), // Dark text
        surface: Color(0xFF1A1A1A), // Dark background
        onSurface: Color(0xFFF5F5F5), // Light text
        surfaceContainerHighest: Color(0xFF171717), // Darker background
        onSurfaceVariant: Color(0xFFB3B3B3), // Muted text
        background: Color(0xFF141414), // Darkest background
        onBackground: Color(0xFFF5F5F5), // Light text
        error: Color(0xFFEF4444), // Red
        onError: Color(0xFFF5F5F5), // Light text
        outline: Color(0xFF404040), // Border
        shadow: Color(0xFF000000), // Shadow
      ),
      scaffoldBackgroundColor: const Color(0xFF141414), // Darkest background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Color(0xFFF5F5F5),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1A1A1A),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF171717),
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
          borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
        ),
      ),
    );
  }

  // Custom Light Theme (DaisyUI Lofi)
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF262626), // Dark gray
        onPrimary: Color(0xFFFFFFFF), // White text
        secondary: Color(0xFF404040), // Medium gray
        onSecondary: Color(0xFFFFFFFF), // White text
        tertiary: Color(0xFF525252), // Gray (accent)
        onTertiary: Color(0xFFFFFFFF), // White text
        surface: Color(0xFFFFFFFF), // White background
        onSurface: Color(0xFF000000), // Black text
        surfaceContainerHighest: Color(0xFFF7F7F7), // Light gray
        onSurfaceVariant: Color(0xFF666666), // Muted text
        background: Color(0xFFF0F0F0), // Light gray background
        onBackground: Color(0xFF000000), // Black text
        error: Color(0xFFF97316), // Orange
        onError: Color(0xFFFFFFFF), // White text
        outline: Color(0xFFE0E0E0), // Border
        shadow: Color(0xFF000000), // Shadow
      ),
      scaffoldBackgroundColor: const Color(0xFFF0F0F0), // Light gray background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF000000),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF262626),
          foregroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
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
          borderSide: const BorderSide(color: Color(0xFF262626), width: 2),
        ),
      ),
    );
  }

  // Get current theme
  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;
}
