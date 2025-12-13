import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Services/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

final fetchTasksProvider = FutureProvider.family((ref, String userEmail) {
  final taskService = ref.watch(taskServiceProvider);
  return taskService.fetchTasks(userEmail);
});

final taskProvider = Provider<TaskController>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  return TaskController(taskService: taskService, ref: ref);
});

class TaskController {
  TaskService taskService;
  Ref ref;
  TaskController({required this.taskService, required this.ref});

  Future<void> addTask(TaskModel task) async {
    await taskService.addTask(task);
    ref.invalidate(fetchTasksProvider(task.userEmail));
  }

  Future<void> updateTask(TaskModel task) async {
    await taskService.updateTask(task);
    ref.invalidate(fetchTasksProvider(task.userEmail));
  }

  Future<void> deleteTask(TaskModel task) async {
    await taskService.deleteTask(task.uniqueId);
    ref.invalidate(fetchTasksProvider(task.userEmail));
  }
}
