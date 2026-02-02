import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/lang_selection_provider.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/status_selection_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Providers/weather_provider.dart';
import 'package:frontend/Services/task_filter_service.dart';
import 'package:frontend/Widgets/flow_app_bar.dart';
import 'package:frontend/Widgets/flow_category_button.dart';
import 'package:frontend/Widgets/flow_drawer.dart';
import 'package:frontend/Widgets/flow_header.dart';
import 'package:frontend/Widgets/flow_modal.dart';
import 'package:frontend/Widgets/flow_overview_block.dart';
import 'package:frontend/Widgets/flow_status_button.dart';
import 'package:frontend/Widgets/flow_task_item.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upgrader/upgrader.dart';

final _modalCategoryProvider = StateProvider.autoDispose<String>((ref) => '');
final _modalPriorityProvider = StateProvider.autoDispose<String>((ref) => '');
final _modalDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final useLocalDb = !isOnline || !isLoggedIn;
    return UpgradeAlert(
      upgrader: Upgrader(
        minAppVersion: '1.0.0',
        countryCode: ref.watch(langSelectionProvider),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const FlowDrawer(),
        body: Column(
          children: [
            const Expanded(child: _HomeHeader()),
            Expanded(
              flex: 3,
              child: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  final userEmail = ref
                      .read(prefProvider)
                      .maybeWhen(
                        data: (prefs) => prefs.getString('userEmail') ?? '',
                        orElse: () => '',
                      );
                  if (userEmail.isNotEmpty) {
                    ref.invalidate(tasksListProvider(userEmail));
                  }
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  children: [
                    30.verticalSpace,
                    const _WeatherSuggestion(),
                    20.verticalSpace,
                    useLocalDb
                        ? const _OverviewSectionOffline()
                        : const _OverviewSection(),
                    20.verticalSpace,
                    const _StatusFilter(),
                    20.verticalSpace,
                    const _CategoryFilter(),
                    20.verticalSpace,
                    if (useLocalDb)
                      const _TaskListOffline()
                    else
                      const _TasksList(),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlowHeader(
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
                      categorySelectionProvider: _modalCategoryProvider,
                      prioritySelectionProvider: _modalPriorityProvider,
                      pickedDateProvider: _modalDateProvider,
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
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        25.verticalSpace,
        Text(
          DateTime.now().toString().split(' ')[0],
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17.5.sp),
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
    );
  }
}

class _WeatherSuggestion extends ConsumerWidget {
  const _WeatherSuggestion();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestion = ref.watch(weatherSuggestionProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorLight,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 3.r,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 30.r),
          15.horizontalSpace,
          Expanded(
            child: Text(
              suggestion,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewSection extends ConsumerWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref
        .watch(prefProvider)
        .maybeWhen(
          data: (prefs) => prefs.getString('userEmail') ?? '',
          orElse: () => '',
        );

    if (userEmail.isEmpty) {
      return const FlowOverviewBlock(
        completionPercentage: 0,
        activeTasks: 0,
        completedTasks: 0,
        urgentTasks: 0,
      );
    }
    return ref
        .watch(tasksListProvider(userEmail))
        .when(
          data: (tasks) {
            final total = tasks.length;
            final completed = tasks.where((t) => t.isCompleted).length;
            final active = total - completed;
            final urgent = tasks
                .where((t) => !t.isCompleted && t.priority == 'high')
                .length;
            final percentage = total > 0
                ? ((completed / total) * 100).round()
                : 0;

            return FlowOverviewBlock(
              completionPercentage: percentage,
              activeTasks: active,
              completedTasks: completed,
              urgentTasks: urgent,
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
          error: (e, s) => Center(child: Text('Error: $e')),
        );
  }
}

class _OverviewSectionOffline extends ConsumerWidget {
  const _OverviewSectionOffline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(fetchlocalDB);
    return tasks.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const FlowOverviewBlock(
            completionPercentage: 0,
            activeTasks: 0,
            completedTasks: 0,
            urgentTasks: 0,
          );
        }
        final total = tasks.length;
        final completed = tasks.where((t) => t.isCompleted).length;
        final active = total - completed;
        final urgent = tasks
            .where((t) => !t.isCompleted && t.priority == 'high')
            .length;
        final percentage = total > 0 ? ((completed / total) * 100).round() : 0;

        return FlowOverviewBlock(
          completionPercentage: percentage,
          activeTasks: active,
          completedTasks: completed,
          urgentTasks: urgent,
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          spacing: 1.w,
          children: statuses(context).entries.map((entry) {
            return FlowStatusButton(
              title: entry.value,
              value: entry.key.toLowerCase(),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: categories.map((e) => FlowCategoryButton(title: e)).toList(),
      ),
    );
  }
}

class _TasksList extends ConsumerWidget {
  const _TasksList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(prefProvider);
    final emailAsync = userEmail.maybeWhen(
      data: (prefs) => prefs.getString('userEmail') ?? '',
      orElse: () => '',
    );
    if (emailAsync.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 50.r, color: Colors.grey),
            Text(
              AppLocalizations.of(context)!.loginStatment,
              style: GoogleFonts.inter(fontSize: 18.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ref
        .watch(tasksListProvider(emailAsync))
        .when(
          data: (tasks) {
            final filtered = filterTasks(tasks, ref);
            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  'No tasks yet',
                  style: GoogleFonts.inter(fontSize: 20.sp, color: Colors.grey),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) =>
                  FlowTaskItem(task: filtered[index]),
              separatorBuilder: (_, __) => 10.verticalSpace,
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
          error: (e, s) => Center(child: Text('Error: $e')),
        );
  }
}

class _TaskListOffline extends ConsumerWidget {
  const _TaskListOffline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(fetchlocalDB);
    return tasks.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Center(
            child: Text(
              'No tasks yet',
              style: GoogleFonts.inter(fontSize: 20.sp, color: Colors.grey),
            ),
          );
        }
        final filtered = filterTasks(tasks, ref);
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) => FlowTaskItem(task: filtered[index]),
          separatorBuilder: (_, __) => 10.verticalSpace,
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
