import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStatsBlock extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  const CustomStatsBlock({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 104.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: color.withAlpha(30),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30.r),
              Text(
                title,
                style: GoogleFonts.inter(color: color, fontSize: 15.sp),
              ),
              5.verticalSpace,
              Text(
                count.toString(),
                style: GoogleFonts.inter(color: color, fontSize: 17.5.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
