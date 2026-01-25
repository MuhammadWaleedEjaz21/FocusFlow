import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
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
    Future.microtask(() {
      ref.read(_categorySelectionProvider.notifier).state = task.category;
      ref.read(_prioritySelectionProvider.notifier).state = task.priority;
      ref.read(_pickedDateProvider.notifier).state = task.dueDate;
    });
    return ExpansionTile(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,

      leading: IconButton(
        onPressed: () async {
          final taskController = await ref.read(taskProvider.future);
          await taskController.updateTask(
            task.copyWith(isCompleted: !task.isCompleted),
          );
        },
        icon: Icon(
          task.isCompleted ? Icons.check_circle_outline : Icons.circle_outlined,
          size: 35.r,
          color: task.isCompleted ? Colors.green : Colors.grey.shade700,
        ),
      ),
      showTrailingIcon: false,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: Theme.of(context).shadowColor),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: Theme.of(context).shadowColor),
      ),
      title: Text(
        task.title,
        style: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: task.isCompleted
              ? Colors.blueGrey.shade400
              : Theme.of(context).hintColor,
          decoration: task.isCompleted
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
            task.description,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              color: task.isCompleted
                  ? Colors.blueGrey.shade400
                  : Theme.of(context).hintColor.withAlpha(100),
            ),
          ),
          30.verticalSpace,
          Row(
            spacing: 5.w,
            children: [
              FlowLabel(
                title: task.category,
                color: Theme.of(context).primaryColor,
              ),
              FlowLabel(title: task.priority, color: Colors.red),
              FlowLabel(
                title: task.dueDate.toString().split(' ')[0],
                color: Colors.deepOrange,
              ),
            ],
          ),
        ],
      ),
      children: [
        Row(
          spacing: 5.w,
          children: [
            5.horizontalSpace,
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
                      taskUniqueId: task.uniqueId,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 20.sp,
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
                    final taskController = ref.read(taskProvider.future);
                    taskController.then((controller) {
                      controller.deleteTask(
                        task.copyWith(userEmail: userEmail),
                      );
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Delete'),
              ),
            ),
            5.horizontalSpace,
          ],
        ),
        10.verticalSpace,
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
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: color.withAlpha(75),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        title.replaceFirst(RegExp(r'[a-z]'), title[0].toUpperCase()),
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
