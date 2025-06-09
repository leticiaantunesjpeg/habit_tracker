import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ColorScheme _currentTheme;
  
  ThemeProvider(this._currentTheme);
  
  ColorScheme get currentTheme => _currentTheme;
  
  void setTheme(ColorScheme theme) async {
    _currentTheme = theme;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('primaryColor', theme.primary.value);
    prefs.setInt('secondaryColor', theme.secondary.value);
    prefs.setInt('surfaceColor', theme.surface.value);
    prefs.setInt('backgroundColor', theme.background.value);
  }
  
  static Future<ThemeProvider> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('primaryColor')) {
        final primaryColor = Color(prefs.getInt('primaryColor')!);
        final secondaryColor = Color(prefs.getInt('secondaryColor')!);
        final surfaceColor = Color(prefs.getInt('surfaceColor')!);
        final backgroundColor = Color(prefs.getInt('backgroundColor')!);
        
        final customTheme = ColorScheme.dark(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          background: backgroundColor,
          error: const Color(0xFFE74C3C),
        );
        
        return ThemeProvider(customTheme);
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
    
    return ThemeProvider(
      const ColorScheme.dark(
        primary: Color(0xFF3498DB),
        secondary: Color(0xFF9B59B6),
        surface: Color(0xFF2C3E50),
        error: Color(0xFFE74C3C),
        background: Color(0xFF1E2B3C),
      ),
    );
  }
}
