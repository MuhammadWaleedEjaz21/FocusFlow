import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:frontend/Providers/status_selection_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Services/task_filter_service.dart';
import 'package:frontend/Widgets/flow_app_bar.dart';
import 'package:frontend/Widgets/flow_category_button.dart';
import 'package:frontend/Widgets/flow_header.dart';
import 'package:frontend/Widgets/flow_modal.dart';
import 'package:frontend/Widgets/flow_overview_block.dart';
import 'package:frontend/Widgets/flow_status_button.dart';
import 'package:frontend/Widgets/flow_task_item.dart';
import 'package:google_fonts/google_fonts.dart';

final _categorySelectionProvider = StateProvider<String>((ref) => '');
final _prioritySelectionProvider = StateProvider<String>((ref) => '');
final _pickedDateProvider = StateProvider<DateTime?>((ref) => null);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: FlowHeader(
              children: [
                45.verticalSpace,
                FlowAppBar(
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FlowModal(
                              categorySelectionProvider:
                                  _categorySelectionProvider,
                              prioritySelectionProvider:
                                  _prioritySelectionProvider,
                              pickedDateProvider: _pickedDateProvider,
                              titleController: TextEditingController(),
                              descriptionController: TextEditingController(),
                            );
                          },
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.white,
                        iconSize: 40.r,
                      ),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                25.verticalSpace,
                Text(
                  DateTime.now().toString().split(' ')[0],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 17.5.sp,
                  ),
                ),
                Text(
                  'FocusFlow',
                  style: GoogleFonts.inter(
                    fontSize: 35.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                children: [
                  30.verticalSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      final prefsAsync = ref.watch(prefProvider);
                      return prefsAsync.when(
                        error: (error, stackTrace) => Center(
                          child: Text('Error loading preferences: $error'),
                        ),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        data: (prefs) {
                          final userEmail = prefs.getString('userEmail') ?? '';
                          final isLoggedIn =
                              prefs.getBool('isLoggedIn') ?? false;

                          if (!isLoggedIn || userEmail.isEmpty) {
                            return FlowOverviewBlock(
                              completionPercentage: 0,
                              activeTasks: 0,
                              completedTasks: 0,
                              urgentTasks: 0,
                            );
                          }
                          final tasksAsyncValue = ref.watch(
                            tasksListProvider(userEmail),
                          );
                          return tasksAsyncValue.when(
                            error: (error, stackTrace) => Center(
                              child: Text('Error loading tasks: $error'),
                            ),
                            loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            data: (tasks) {
                              final totalTasks = tasks.length;
                              final completedTasks = tasks
                                  .where((task) => task.isCompleted)
                                  .length;
                              final activeTasks = tasks
                                  .where((task) => !task.isCompleted)
                                  .length;
                              final urgentTasks = tasks
                                  .where(
                                    (task) =>
                                        !task.isCompleted &&
                                        task.priority == 'high',
                                  )
                                  .length;
                              final completionPercentage = totalTasks > 0
                                  ? ((completedTasks / totalTasks) * 100)
                                        .round()
                                  : 0;

                              return FlowOverviewBlock(
                                completionPercentage: completionPercentage,
                                activeTasks: activeTasks,
                                completedTasks: completedTasks,
                                urgentTasks: urgentTasks,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  20.verticalSpace,
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        spacing: 1.w,
                        children: statuses
                            .map((e) => FlowStatusButton(title: e))
                            .toList(),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: categories
                          .map((e) => FlowCategoryButton(title: e))
                          .toList(),
                    ),
                  ),
                  20.verticalSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      final prefsAsync = ref.watch(prefProvider);
                      return prefsAsync.when(
                        data: (prefs) {
                          final isLoggedIn =
                              prefs.getBool('isLoggedIn') ?? false;
                          final userEmail = prefs.getString('userEmail') ?? '';

                          if (!isLoggedIn || userEmail.isEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 50.r,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Please log in to view your tasks',
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final fetchTasksAsyncValue = ref.watch(
                            tasksListProvider(userEmail),
                          );

                          return fetchTasksAsyncValue.when(
                            data: (tasks) {
                              final filteredTasks = filterTasks(tasks, ref);
                              if (filteredTasks.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No tasks yet',
                                    style: GoogleFonts.inter(
                                      fontSize: 20.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    FlowTaskItem(task: filteredTasks[index]),
                                separatorBuilder: (context, index) =>
                                    10.verticalSpace,
                                itemCount: filteredTasks.length,
                              );
                            },
                            loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            error: (error, stack) => Center(
                              child: Text(
                                'Error loading tasks: $error',
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        error: (error, stack) => Center(
                          child: Text(
                            'Error loading preferences: $error',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
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
