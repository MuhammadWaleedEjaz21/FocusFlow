import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 35),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.deepPurple,
  ),

  textTheme: TextTheme(
    titleLarge: GoogleFonts.inter(
      color: Colors.white,
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
    ),
  ),

  shadowColor: Colors.transparent,

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 34, 34, 51),
    ),
  ),

  cardColor: const Color.fromARGB(255, 40, 40, 60),
  highlightColor: Colors.grey.withAlpha(50),
);
