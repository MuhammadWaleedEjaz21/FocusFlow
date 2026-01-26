import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Widgets/flow_status_block.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowOverviewBlock extends StatelessWidget {
  const FlowOverviewBlock({
    super.key,
    required this.completionPercentage,
    required this.activeTasks,
    required this.completedTasks,
    required this.urgentTasks,
  });

  final int completionPercentage;
  final int activeTasks;
  final int completedTasks;
  final int urgentTasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 5.r,
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppLocalizations.of(context)!.overview,
                  style: GoogleFonts.inter(
                    fontSize: 30.r,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Spacer(),
                Container(
                  height: 90.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight,
                      ],
                      stops: [0, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),

                  child: Center(
                    child: Text(
                      '$completionPercentage%',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 25.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5.w,
              children: [
                FlowStatusBlock(
                  categoryTitle: AppLocalizations.of(context)!.active,
                  icon: Icons.circle_outlined,
                  count: activeTasks,
                  color: Theme.of(context).primaryColor,
                ),
                FlowStatusBlock(
                  categoryTitle: AppLocalizations.of(context)!.completed,
                  icon: Icons.check_circle_outline,
                  count: completedTasks,
                  color: Colors.green,
                ),
                FlowStatusBlock(
                  categoryTitle: AppLocalizations.of(context)!.urgent,
                  icon: Icons.error_outline,
                  count: urgentTasks,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
