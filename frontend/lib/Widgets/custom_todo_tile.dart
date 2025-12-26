import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:google_fonts/google_fonts.dart';

final isCompleted = StateProvider.autoDispose.family<bool, TaskModel>(
  (ref, task) => task.isCompleted,
);

class CustomTodoTile extends ConsumerWidget {
  final TaskModel task;
  const CustomTodoTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(isCompleted(task));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        backgroundColor: Theme.of(context).cardColor,
        collapsedBackgroundColor: Theme.of(context).cardColor,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        showTrailingIcon: false,
        tilePadding: EdgeInsets.all(7.5.r),
        leading: IconButton(
          onPressed: () async {
            final next = !completed;
            ref.read(isCompleted(task).notifier).state = next;
            await ref
                .read(taskProvider)
                .updateTask(task.copyWith(isCompleted: next));
          },
          icon: Icon(
            completed ? Icons.check_circle_outline : Icons.circle_outlined,
            color: completed ? Colors.green : Colors.grey,
            size: 35.r,
          ),
        ),
        title: Text(
          task.title,
          style: GoogleFonts.inter(
            color: completed
                ? Colors.grey
                : Theme.of(context).textTheme.titleMedium!.color,
            decoration: completed ? TextDecoration.lineThrough : null,
            decorationColor: Colors.grey,
            decorationThickness: 2,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 15.sp),
            ),
            25.verticalSpace,
            Row(
              spacing: 10.w,
              children: [
                Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withAlpha(50),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    task.category,
                    style: GoogleFonts.inter(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(50),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    task.priority,
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(50),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    task.dueDate.toString().split(' ')[0],
                    style: GoogleFonts.inter(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Edit',
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(taskProvider).deleteTask(task);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }
}
