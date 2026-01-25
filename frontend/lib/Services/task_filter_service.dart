import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:frontend/Providers/status_selection_provider.dart';

List<TaskModel> filterTasks(List<TaskModel> tasksList, WidgetRef ref) {
  final filterStatus = ref.watch(statusSelectionProvider);
  final filterCategory = ref.watch(categorySelectionProvider);
  return tasksList.where((task) {
    final statusMatch =
        filterStatus == 'all' ||
        (filterStatus == 'active' && !task.isCompleted) ||
        (filterStatus == 'completed' && task.isCompleted);
    final categoryMatch =
        filterCategory == 'all' || task.category == filterCategory;
    return statusMatch && categoryMatch;
  }).toList();
}
