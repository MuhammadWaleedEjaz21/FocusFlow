import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_form_field.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowModal extends StatelessWidget {
  final StateProvider<String> categorySelectionProvider;
  final StateProvider<String> prioritySelectionProvider;
  final StateProvider<DateTime?> pickedDateProvider;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool toUpdate;
  final String? taskUniqueId;
  const FlowModal({
    super.key,
    required this.categorySelectionProvider,
    required this.prioritySelectionProvider,
    required this.pickedDateProvider,
    required this.titleController,
    required this.descriptionController,
    this.toUpdate = false,
    this.taskUniqueId,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(15.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.newTask,
                style: GoogleFonts.inter(fontSize: 30.sp),
              ),
              30.verticalSpace,
              FlowFormField(
                labelText: AppLocalizations.of(context)!.taskTitle,
                hintText: AppLocalizations.of(context)!.taskTitle,
                controller: titleController,
              ),
              20.verticalSpace,
              FlowFormField(
                labelText: AppLocalizations.of(context)!.description,
                hintText: AppLocalizations.of(context)!.description,
                controller: descriptionController,
                maxLines: 4,
              ),
              20.verticalSpace,
              Text(
                AppLocalizations.of(context)!.category,
                style: GoogleFonts.inter(
                  fontSize: 17.5.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.verticalSpace,
              Consumer(
                builder: (context, ref, child) {
                  final categorySelection = ref.watch(
                    categorySelectionProvider,
                  );
                  return SizedBox(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 3.5,
                      ),
                      itemBuilder: (context, index) => categories
                          .map(
                            (e) => ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(categorySelectionProvider.notifier)
                                    .state = e
                                    .toLowerCase();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    categorySelection == e.toLowerCase()
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade200,
                                foregroundColor:
                                    categorySelection == e.toLowerCase()
                                    ? Colors.white
                                    : Colors.blueGrey.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                e,
                                style: GoogleFonts.inter(fontSize: 15.sp),
                              ),
                            ),
                          )
                          .toList()[index + 1],
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  );
                },
              ),
              20.verticalSpace,
              Text(
                AppLocalizations.of(context)!.priority,
                style: GoogleFonts.inter(
                  fontSize: 17.5.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.verticalSpace,
              Consumer(
                builder: (context, ref, child) {
                  final prioritySelection = ref.watch(
                    prioritySelectionProvider,
                  );
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(prioritySelectionProvider.notifier).state =
                                'low';
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: prioritySelection == 'low'
                                ? Colors.green
                                : Colors.grey.shade200,
                            foregroundColor: prioritySelection == 'low'
                                ? Colors.white
                                : Colors.blueGrey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            textStyle: GoogleFonts.inter(fontSize: 12.5.sp),
                          ),
                          child: Text('Low'),
                        ),
                      ),
                      10.horizontalSpace,
                      ElevatedButton(
                        onPressed: () {
                          ref.read(prioritySelectionProvider.notifier).state =
                              'medium';
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: prioritySelection == 'medium'
                              ? Colors.orange
                              : Colors.grey.shade200,
                          foregroundColor: prioritySelection == 'medium'
                              ? Colors.white
                              : Colors.blueGrey.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          textStyle: GoogleFonts.inter(fontSize: 15.sp),
                        ),
                        child: Text(
                          'Medium',
                          style: GoogleFonts.inter(fontSize: 12.5.sp),
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(prioritySelectionProvider.notifier).state =
                                'high';
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: prioritySelection == 'high'
                                ? Colors.red
                                : Colors.grey.shade200,
                            foregroundColor: prioritySelection == 'high'
                                ? Colors.white
                                : Colors.blueGrey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            textStyle: GoogleFonts.inter(fontSize: 12.5.sp),
                          ),
                          child: Text('High'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              20.verticalSpace,
              Text(
                AppLocalizations.of(context)!.dueDate,
                style: GoogleFonts.inter(
                  fontSize: 17.5.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.verticalSpace,
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        ref.read(pickedDateProvider.notifier).state =
                            pickedDate;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.blueGrey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      textStyle: GoogleFonts.inter(fontSize: 15.sp),
                    ),
                    child: Text(AppLocalizations.of(context)!.dueDate),
                  );
                },
              ),
              30.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final categorySelection = ref.watch(
                          categorySelectionProvider,
                        );
                        final prioritySelection = ref.watch(
                          prioritySelectionProvider,
                        );
                        final pickedDate = ref.watch(pickedDateProvider);
                        return ElevatedButton(
                          onPressed: () async {
                            ref.read(prefProvider.future).then((prefs) async {
                              final userEmail =
                                  prefs.getString('userEmail') ?? '';
                              final TaskModel newTask = TaskModel(
                                userEmail: userEmail,
                                uniqueId: toUpdate
                                    ? taskUniqueId!
                                    : DateTime.now().toString(),
                                title: titleController.text,
                                description: descriptionController.text,
                                category: categorySelection,
                                priority: prioritySelection,
                                dueDate: pickedDate ?? DateTime.now(),
                              );
                              await ref.read(taskProvider.future).then((
                                taskRepo,
                              ) async {
                                if (toUpdate) {
                                  await taskRepo.updateTask(newTask);
                                } else {
                                  await taskRepo.addTask(newTask);
                                }
                                Navigator.of(context).pop();
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            textStyle: GoogleFonts.inter(fontSize: 18.sp),
                          ),
                          child: Text(AppLocalizations.of(context)!.save),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
