import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// This class manages all font-related constants and styles for the app
class AppFonts {
  // For primary text like headlines and titles - Montserrat is a more professional and modern font
  static final TextStyle primaryFont = GoogleFonts.montserrat();
  
  // For body text - Inter provides excellent readability for body text
  static final TextStyle bodyFont = GoogleFonts.inter();
  
  // For accent elements or buttons
  static final TextStyle accentFont = GoogleFonts.sourceSans3();

  // Headline Styles
  static TextStyle headingLarge({Color? color}) => GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.3,
    height: 1.2,
  );
  
  static TextStyle headingMedium({Color? color}) => GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.2,
    height: 1.2,
  );
  
  static TextStyle headingSmall({Color? color}) => GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.1,
    height: 1.3,
  );

  // Body Text Styles
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
    letterSpacing: 0.4,
    height: 1.4,
  );

  // Button Styles
  static TextStyle buttonText({Color? color}) => GoogleFonts.sourceSans3(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: 0.5,
  );

  // Caption Styles
  static TextStyle captionText({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: color,
    letterSpacing: 0.4,
  );
  
  // Subtitle Styles
  static TextStyle subtitleLarge({Color? color}) => GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0.1,
    height: 1.4,
  );
  
  // Label Styles
  static TextStyle labelText({Color? color}) => GoogleFonts.sourceSans3(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
  );
}
