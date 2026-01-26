import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/main.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowAppBar extends StatelessWidget {
  final List<Widget> actions;
  final String? title;
  const FlowAppBar({super.key, this.actions = const [], this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DrawerButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            iconSize: WidgetStatePropertyAll(40.r),
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        if (title != null) ...[
          25.horizontalSpace,
          Text(
            title!,
            style: GoogleFonts.inter(
              fontSize: 35.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        Spacer(),
        ...actions,
      ],
    );
  }
}
