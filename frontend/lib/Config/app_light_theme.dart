import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.deepPurple),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.inter(
      color: Colors.black87,
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
    ),
  ),
  shadowColor: Colors.grey.withAlpha(50),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blueGrey,
      backgroundColor: Colors.white,
    ),
  ),
  cardColor: Colors.white,
  highlightColor: Colors.grey.withAlpha(50),
);
