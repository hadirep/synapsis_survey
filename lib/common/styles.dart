import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFFFFFFF);
const Color secondaryColor = Color(0xFF1fa0c9);
const Color textFieldColor = Color(0xfffbfbfb);
const Color textColor = Color(0xff757575);
const Color createdTextColor = Color(0xff107c41);
const Color blackColor = Colors.black;
const Color dividerColor = Color(0xffeef6f9);
const Color buttonColor = Color(0xffd2ecf4);
const Color indicatorColor = Color(0xffd9d9d9);

final TextTheme myTextTheme = TextTheme(
  displayLarge: GoogleFonts.inter(fontSize: 94, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.inter(fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.inter(fontSize: 47, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.inter(fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
  bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);