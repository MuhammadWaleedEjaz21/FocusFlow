import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_modal.dart';
import 'package:google_fonts/google_fonts.dart';

final _categorySelectionProvider = StateProvider<String>((ref) => '');
final _prioritySelectionProvider = StateProvider<String>((ref) => '');
final _pickedDateProvider = StateProvider<DateTime?>((ref) => null);

class FlowTaskItem extends ConsumerWidget {
  final TaskModel task;
  const FlowTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    final isOnline = ref.watch(isOnlineProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final useLocalDb = !isOnline || !isLoggedIn;

    Future.microtask(() {
      ref.read(_categorySelectionProvider.notifier).state = task.category;
      ref.read(_prioritySelectionProvider.notifier).state = task.priority;
      ref.read(_pickedDateProvider.notifier).state = task.dueDate;
    });

    TaskModel currentTask = task;
    if (!useLocalDb) {
      final tasksAsyncValue = ref.watch(tasksListProvider(task.userEmail));
      currentTask = tasksAsyncValue.maybeWhen(
        data: (tasks) {
          try {
            return tasks.firstWhere((t) => t.uniqueId == task.uniqueId);
          } catch (e) {
            return task;
          }
        },
        orElse: () => task,
      );
    }

    return ExpansionTile(
      trailing: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          final controller = await ref.read(localDBProvider.future);
          if (currentTask.isFavorite == true) {
            await controller.removeFromFavourites(currentTask);
          } else {
            await controller.addtoFavourites(currentTask);
          }
        },
        icon: Icon(
          currentTask.isFavorite ? Icons.favorite : Icons.favorite_outline,
          size: 28.r,
          color: currentTask.isFavorite ? Colors.red : Colors.grey,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,

      leading: IconButton(
        onPressed: () async {
          if (useLocalDb) {
            final localDb = await ref.read(localDBProvider.future);
            await localDb.updateLocalTask(
              currentTask.copyWith(isCompleted: !currentTask.isCompleted),
            );
          } else {
            final taskController = await ref.read(taskProvider.future);
            await taskController.updateTask(
              currentTask.copyWith(isCompleted: !currentTask.isCompleted),
            );
          }
        },
        icon: Icon(
          currentTask.isCompleted
              ? Icons.check_circle_outline
              : Icons.circle_outlined,
          size: 28.r,
          color: currentTask.isCompleted ? Colors.green : Colors.grey.shade700,
        ),
      ),
      showTrailingIcon: useLocalDb ? false : true,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: Theme.of(context).shadowColor, width: 1.5),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: Theme.of(context).shadowColor, width: 1.5),
      ),
      title: Text(
        currentTask.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: currentTask.isCompleted
              ? Colors.blueGrey.shade400
              : Theme.of(context).hintColor,
          decoration: currentTask.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          decorationColor: Colors.blueGrey.shade400,
        ),
      ),
      subtitle: ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            currentTask.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: currentTask.isCompleted
                  ? Colors.blueGrey.shade400
                  : Theme.of(context).hintColor.withAlpha(150),
            ),
          ),
          15.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8.w,
              children: [
                FlowLabel(
                  title: currentTask.category,
                  color: Theme.of(context).primaryColor,
                ),
                FlowLabel(title: currentTask.priority, color: Colors.red),
                FlowLabel(
                  title: currentTask.dueDate.toString().split(' ')[0],
                  color: Colors.deepOrange,
                ),
              ],
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => FlowModal(
                        categorySelectionProvider: _categorySelectionProvider,
                        prioritySelectionProvider: _prioritySelectionProvider,
                        pickedDateProvider: _pickedDateProvider,
                        titleController: titleController,
                        descriptionController: descriptionController,
                        toUpdate: true,
                        taskUniqueId: currentTask.uniqueId,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Update'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(prefProvider.future).then((pref) {
                      final userEmail = pref.getString('userEmail') ?? '';
                      if (!useLocalDb) {
                        final taskController = ref.read(taskProvider.future);
                        taskController.then((controller) {
                          controller.deleteTask(
                            currentTask.copyWith(userEmail: userEmail),
                          );
                        });
                      } else {
                        ref.read(localDBProvider.future).then((
                          localDBRepo,
                        ) async {
                          await localDBRepo.deleteLocalTask(
                            currentTask.copyWith(userEmail: userEmail),
                          );
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FlowLabel extends StatelessWidget {
  final String title;
  final Color color;
  const FlowLabel({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withAlpha(75),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        title.replaceFirst(RegExp(r'[a-z]'), title[0].toUpperCase()),
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
