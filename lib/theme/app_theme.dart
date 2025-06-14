import 'package:flutter/material.dart';
import 'font_constants.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3498DB);
  static const Color primaryDarkColor = Color(0xFF2980B9);
  static const Color accentColor = Color(0xFF9B59B6);
  static const Color backgroundColor = Color(0xFF1E2B3C);
  static const Color cardColor = Color(0xFF2C3E50);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFBDC3C7);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryDarkColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, Color(0xFF34495E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pendingGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getCardGradient(bool isCompleted) {
    return isCompleted
        ? const LinearGradient(
            colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  static TextStyle get headingStyle => AppFonts.headingMedium(color: textPrimaryColor);

  static TextStyle get subheadingStyle => AppFonts.headingSmall(color: textPrimaryColor);
  
  static TextStyle get subtitleStyle => AppFonts.subtitleLarge(color: textPrimaryColor);

  static TextStyle get bodyStyle => AppFonts.bodyLarge(color: textPrimaryColor);

  static TextStyle get captionStyle => AppFonts.captionText(color: textSecondaryColor);

  static TextStyle get buttonTextStyle => AppFonts.buttonText(color: textPrimaryColor);
  
  static TextStyle get labelStyle => AppFonts.labelText(color: textSecondaryColor);

  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
    gradient: primaryGradient,
  );

  static InputDecoration textFieldDecoration(String label, {Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppFonts.bodyMedium(color: textSecondaryColor),
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: textSecondaryColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: cardColor.withOpacity(0.7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 5,
    shadowColor: primaryColor.withOpacity(0.5),
  );

  static TextTheme createTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AppFonts.primaryFont.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
      displayMedium: AppFonts.primaryFont.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
      displaySmall: AppFonts.primaryFont.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        height: 1.3,
      ),
      headlineLarge: AppFonts.headingLarge(color: colorScheme.onSurface),
      headlineMedium: AppFonts.headingMedium(color: colorScheme.onSurface),
      headlineSmall: AppFonts.headingSmall(color: colorScheme.onSurface),
      titleLarge: AppFonts.subtitleLarge(color: colorScheme.onSurface),
      titleMedium: AppFonts.bodyFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        letterSpacing: 0.15,
      ),
      titleSmall: AppFonts.labelText(color: colorScheme.onSurface),
      bodyLarge: AppFonts.bodyLarge(color: colorScheme.onSurface),
      bodyMedium: AppFonts.bodyMedium(color: colorScheme.onSurface),
      bodySmall: AppFonts.bodySmall(color: colorScheme.onSurface),
      labelLarge: AppFonts.buttonText(color: colorScheme.onSurface),
      labelMedium: AppFonts.labelText(color: colorScheme.onSurface),
      labelSmall: AppFonts.captionText(color: colorScheme.onSurface),
    );
  }
}
