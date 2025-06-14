import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static final TextStyle primaryFont = GoogleFonts.montserrat();
  static final TextStyle bodyFont = GoogleFonts.inter();
  static final TextStyle accentFont = GoogleFonts.sourceSans3();

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

  static TextStyle buttonText({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle captionText({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
        letterSpacing: 0.4,
      );

  static TextStyle subtitleLarge({Color? color}) => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle labelText({Color? color}) => GoogleFonts.sourceSans3(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.5,
      );
}
