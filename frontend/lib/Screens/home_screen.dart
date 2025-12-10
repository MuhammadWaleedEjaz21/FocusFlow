import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/category_status_provider.dart';
import 'package:frontend/Widgets/custom_stats_block.dart';
import 'package:frontend/Widgets/custom_todo_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple],
                    begin: AlignmentGeometry.centerLeft,
                    end: AlignmentGeometry.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 35.r,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.deepPurple,
                              size: 35.r,
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      Text(
                        DateTime.now().toString().split(' ')[0],
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 17.5.sp,
                        ),
                      ),
                      1.verticalSpace,
                      Text(
                        'FocusFlow',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                children: [
                  30.verticalSpace,
                  Container(
                    height: 225.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 10.r,
                          spreadRadius: 5.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Overview',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                height: 75.h,
                                width: 75.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.deepPurple, Colors.purple],
                                    begin: AlignmentGeometry.centerLeft,
                                    end: AlignmentGeometry.bottomRight,
                                    stops: [0.0, 1.0],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '25%',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          20.verticalSpace,
                          Row(
                            spacing: 10.w,
                            children: [
                              CustomStatsBlock(
                                title: 'Active',
                                count: 4,
                                icon: Icons.circle_outlined,
                                color: Colors.deepPurple,
                              ),
                              CustomStatsBlock(
                                title: 'Done',
                                count: 2,
                                icon: Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              CustomStatsBlock(
                                title: 'Urgent',
                                count: 1,
                                icon: Icons.error_outline,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  StatusList(),
                  20.verticalSpace,
                  CategoryList(),
                  20.verticalSpace,
                  CustomTodoTile(
                    title: 'Wake Up Routine',
                    description: 'Due in 2 hours',
                    category: 'Work',
                    priority: 'High',
                    dueDate: DateTime.now(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
