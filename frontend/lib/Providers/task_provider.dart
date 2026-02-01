import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/push_notifications_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefs = SharedPreferences.getInstance();

final taskServiceProvider = Provider<TaskService>((ref) {
  final taskService = TaskService();

  taskService.onTokenExpired = () async {
    final userController = await ref.read(userProvider.future);
    return await userController.refreshAccessToken();
  };

  return taskService;
});

final tasksListProvider = FutureProvider.family<List<TaskModel>, String>((
  ref,
  userEmail,
) async {
  final token = await ref.read(accessTokenProvider.future);
  final taskService = ref.watch(taskServiceProvider);
  return await taskService.fetchTasks(userEmail, token);
});

final taskProvider = FutureProvider<TaskController>((ref) async {
  final token = await ref.read(accessTokenProvider.future);
  return TaskController(ref, token);
});

class TaskController {
  final Ref ref;
  final String token;
  TaskController(this.ref, this.token);

  Future<void> addTask(TaskModel task) async {
    await ref.watch(taskServiceProvider).addTask(task, token);
    try {
      await ref
          .read(pushNotificationServiceProvider)
          .scheduleNotification(
            id: 0,
            title: task.title,
            body: task.description,
            scheduledDate: task.dueDate,
          );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
    ref.invalidate(tasksListProvider(task.userEmail));
  }

  Future<void> updateTask(TaskModel task) async {
    await ref.watch(taskServiceProvider).updateTask(task, token);
    try {
      await ref
          .read(pushNotificationServiceProvider)
          .scheduleNotification(
            id: 0,
            title: task.title,
            body: task.description,
            scheduledDate: task.dueDate,
          );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
    ref.invalidate(tasksListProvider(task.userEmail));
  }

  Future<void> deleteTask(TaskModel task) async {
    await ref.watch(taskServiceProvider).deleteTask(task.uniqueId, token);

    ref.invalidate(tasksListProvider(task.userEmail));
  }
}
