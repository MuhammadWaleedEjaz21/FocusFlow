import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowStatusBlock extends StatelessWidget {
  final String categoryTitle;
  final IconData icon;
  final int count;
  final Color color;
  const FlowStatusBlock({
    super.key,
    required this.categoryTitle,
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      width: 125.w,
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.r, color: color),
          Text(
            categoryTitle,
            style: GoogleFonts.inter(fontSize: 20.sp, color: color),
          ),
          5.verticalSpace,
          Text(
            '$count',
            style: GoogleFonts.inter(color: color, fontSize: 22.5.sp),
          ),
        ],
      ),
    );
  }
}
