import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlowGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final List<Color> colors;
  const FlowGradientButton({super.key, required this.colors, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: 50.h,
        width: 90.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: LinearGradient(
            colors: colors,
            stops: [0, 0.5, 1],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
