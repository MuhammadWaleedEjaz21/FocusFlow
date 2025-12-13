import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/category_status_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Widgets/custom_stats_block.dart';
import 'package:frontend/Widgets/custom_todo_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                  begin: AlignmentGeometry.centerLeft,
                  end: AlignmentGeometry.bottomRight,
                  stops: [0.0, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 50.r),
                  10.verticalSpace,
                  Text(
                    'Waleed Ejaz',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: GoogleFonts.inter(fontSize: 18.sp)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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
                          Builder(
                            builder: (context) {
                              return IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 35.r,
                                ),
                              );
                            },
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
                  Consumer(
                    builder: (context, ref, child) {
                      final taskAsyncValue = ref.watch(
                        fetchTasksProvider('m.waleedejaz2003@gmail.com'),
                      );
                      final active = taskAsyncValue.maybeWhen(
                        data: (tasks) =>
                            tasks.where((task) => !task.isCompleted).length,
                        orElse: () => 0,
                      );
                      final completed = taskAsyncValue.maybeWhen(
                        data: (tasks) =>
                            tasks.where((task) => task.isCompleted).length,
                        orElse: () => 0,
                      );
                      final urgent = taskAsyncValue.maybeWhen(
                        data: (tasks) => tasks
                            .where(
                              (task) =>
                                  !task.isCompleted &&
                                  task.priority.toLowerCase() == 'high',
                            )
                            .length,
                        orElse: () => 0,
                      );
                      final percentage = (active + completed) == 0
                          ? 0
                          : (completed / (active + completed) * 100).round();
                      return Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Overview',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  Container(
                                    height: 75.h,
                                    width: 75.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.deepPurple,
                                          Colors.purple,
                                        ],
                                        begin: AlignmentGeometry.centerLeft,
                                        end: AlignmentGeometry.bottomRight,
                                        stops: [0.0, 1.0],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$percentage%',
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
                                    count: active,
                                    icon: Icons.circle_outlined,
                                    color: Colors.deepPurple,
                                  ),
                                  CustomStatsBlock(
                                    title: 'Done',
                                    count: completed,
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  CustomStatsBlock(
                                    title: 'Urgent',
                                    count: urgent,
                                    icon: Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  30.verticalSpace,
                  StatusList(),
                  20.verticalSpace,
                  CategoryList(),
                  20.verticalSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      final taskAsyncValue = ref.watch(
                        fetchTasksProvider('m.waleedejaz2003@gmail.com'),
                      );
                      return taskAsyncValue.when(
                        error: (error, stackTrace) => Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50.r,
                            ),
                            10.verticalSpace,
                            Text(
                              error.toString().split(': ').last,
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        data: (tasks) {
                          final selectedCategory = ref.watch(
                            categorySelectionProvider,
                          );
                          final status = ref.watch(statusSelectionProvider);

                          final filteredTasks = tasks.where((task) {
                            final matchesCategory =
                                selectedCategory == 'all' ||
                                task.category.toLowerCase() ==
                                    selectedCategory.toLowerCase();
                            final matchesStatus =
                                status == 'all' ||
                                (status == 'active' && !task.isCompleted) ||
                                (status == 'completed' && task.isCompleted);
                            return matchesCategory && matchesStatus;
                          }).toList();

                          return ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                CustomTodoTile(task: filteredTasks[index]),
                            separatorBuilder: (context, index) =>
                                10.verticalSpace,
                            itemCount: filteredTasks.length,
                          );
                        },
                      );
                    },
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
