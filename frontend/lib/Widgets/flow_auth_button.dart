import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const FlowAuthButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
