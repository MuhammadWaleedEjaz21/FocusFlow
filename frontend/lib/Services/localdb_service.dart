import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/localdb.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

Future<void> localDBInitialize() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LocalDBAdapter());

  var favouriteBoxOpened = false;
  const maxRetries = 3;

  for (var attempt = 0; attempt < maxRetries; attempt++) {
    try {
      await Hive.openBox('favouriteBox');
      favouriteBoxOpened = true;
      break;
    } catch (e) {
      try {
        await Hive.deleteBoxFromDisk('favouriteBox');
      } catch (_) {}
    }
  }

  if (!favouriteBoxOpened) {
    try {
      await Hive.deleteBoxFromDisk('favouriteBox');
    } catch (_) {}
  }

  for (var attempt = 0; attempt < maxRetries; attempt++) {
    try {
      await Hive.openBox<String>('pendingDeletionsBox');
      break;
    } catch (e) {
      try {
        await Hive.deleteBoxFromDisk('pendingDeletionsBox');
      } catch (_) {}
    }
  }

  if (favouriteBoxOpened) {
    try {
      final box = Hive.box('favouriteBox');
      for (var key in box.keys.toList()) {
        final task = box.get(key) as LocalDB?;
        if (task != null && !task.isPendingSync && task.isFavorite) {
          task.isPendingSync = true;
          await task.save();
        }
      }
    } catch (e) {}
  }
}

class LocaldbService {
  Ref ref;
  LocaldbService(this.ref);

  Future<bool> _canSyncToServer() async {
    final prefs = await ref.read(prefProvider.future);
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final token = prefs.getString('accessToken') ?? '';
    return isLoggedIn && token.isNotEmpty;
  }

  Future<void> addtoFavourites(TaskModel task) async {
    final box = Hive.box('favouriteBox');

    await box.put(
      task.uniqueId,
      LocalDB()
        ..userEmail = task.userEmail
        ..uniqueId = task.uniqueId
        ..title = task.title
        ..description = task.description
        ..category = task.category
        ..priority = task.priority
        ..dueDate = task.dueDate
        ..isCompleted = task.isCompleted
        ..isFavorite = true,
    );

    if (await _canSyncToServer()) {
      try {
        await ref
            .read(taskProvider.future)
            .then(
              (controller) =>
                  controller.updateTask(task.copyWith(isFavorite: true)),
            );
      } catch (e) {}
    }
  }

  Future<void> removeFromFavourites(TaskModel task) async {
    final box = Hive.box('favouriteBox');
    await box.delete(task.uniqueId);

    if (await _canSyncToServer()) {
      try {
        await ref
            .read(taskProvider.future)
            .then(
              (controller) =>
                  controller.updateTask(task.copyWith(isFavorite: false)),
            );
      } catch (e) {}
    }
  }

  Future<List<TaskModel>> getFavourites() async {
    final prefs = await ref.read(prefProvider.future);
    final currentUserEmail = prefs.getString('userEmail') ?? '';

    final box = Hive.box('favouriteBox');
    return box.values
        .cast<LocalDB>()
        .where((localDB) => localDB.userEmail == currentUserEmail)
        .map(
          (localDB) => TaskModel(
            userEmail: localDB.userEmail,
            uniqueId: localDB.uniqueId,
            title: localDB.title,
            description: localDB.description,
            category: localDB.category,
            priority: localDB.priority,
            dueDate: localDB.dueDate,
            isCompleted: localDB.isCompleted,
            isFavorite: localDB.isFavorite,
          ),
        )
        .toList();
  }

  Future<void> syncFavourites() async {
    if (!await _canSyncToServer()) {
      return;
    }
    final box = Hive.box('favouriteBox');
    final pendingDeletionsBox = Hive.box<String>('pendingDeletionsBox');
    final currentUserEmail = await ref
        .read(prefProvider.future)
        .then((prefs) => prefs.getString('userEmail') ?? '');
    if (currentUserEmail.isEmpty) {
      return;
    }
    final taskList = await ref.read(tasksListProvider(currentUserEmail).future);

    final pendingDeletions = pendingDeletionsBox.values.toList();
    for (var uniqueId in pendingDeletions) {
      final existsOnServer = taskList.any((t) => t.uniqueId == uniqueId);
      if (existsOnServer) {
        try {
          final taskToDelete = taskList.firstWhere(
            (t) => t.uniqueId == uniqueId,
          );
          await ref
              .read(taskProvider.future)
              .then((controller) => controller.deleteTask(taskToDelete));
        } catch (e) {}
      }
    }
    await pendingDeletionsBox.clear();

    final updatedTaskList = await ref.refresh(
      tasksListProvider(currentUserEmail).future,
    );

    final allLocalTasks = box.values.cast<LocalDB>().toList();
    for (var localTask in allLocalTasks) {
      if (!localTask.isPendingSync) {
        continue;
      }

      final existsOnServer = updatedTaskList.any(
        (t) => t.uniqueId == localTask.uniqueId,
      );

      if (!existsOnServer) {
        try {
          final taskToSync = TaskModel(
            userEmail: currentUserEmail,
            uniqueId: localTask.uniqueId,
            title: localTask.title,
            description: localTask.description,
            category: localTask.category,
            priority: localTask.priority,
            dueDate: localTask.dueDate,
            isCompleted: localTask.isCompleted,
            isFavorite: localTask.isFavorite,
          );

          await ref
              .read(taskProvider.future)
              .then((controller) => controller.addTask(taskToSync));

          localTask.isPendingSync = false;
          await localTask.save();
        } catch (e) {}
      } else {
        localTask.isPendingSync = false;
        await localTask.save();
      }
    }

    final currentFavourites = box.values
        .cast<LocalDB>()
        .where((task) => task.isFavorite)
        .toList();

    for (var favTask in currentFavourites) {
      final serverTask = updatedTaskList.firstWhereOrNull(
        (t) => t.uniqueId == favTask.uniqueId,
      );

      if (serverTask != null && !serverTask.isFavorite) {
        try {
          await ref
              .read(taskProvider.future)
              .then(
                (controller) => controller.updateTask(
                  serverTask.copyWith(isFavorite: true),
                ),
              );
        } catch (e) {}
      }
    }
  }

  Future<void> addLocalTask(TaskModel task) async {
    final box = Hive.box('favouriteBox');

    await box.put(
      task.uniqueId,
      LocalDB()
        ..userEmail = task.userEmail
        ..uniqueId = task.uniqueId
        ..title = task.title
        ..description = task.description
        ..category = task.category
        ..priority = task.priority
        ..dueDate = task.dueDate
        ..isCompleted = task.isCompleted
        ..isFavorite = task.isFavorite
        ..isPendingSync = true,
    );
  }

  Future<void> removeLocalTask(String uniqueId) async {
    final box = Hive.box('favouriteBox');
    await box.delete(uniqueId);

    final pendingDeletionsBox = Hive.box<String>('pendingDeletionsBox');
    await pendingDeletionsBox.add(uniqueId);
  }

  Future<void> updateLocalTask(TaskModel task) async {
    final box = Hive.box('favouriteBox');

    final existingTask = box.get(task.uniqueId) as LocalDB?;
    final isPendingSync = existingTask?.isPendingSync ?? true;

    await box.put(
      task.uniqueId,
      LocalDB()
        ..userEmail = task.userEmail
        ..uniqueId = task.uniqueId
        ..title = task.title
        ..description = task.description
        ..category = task.category
        ..priority = task.priority
        ..dueDate = task.dueDate
        ..isCompleted = task.isCompleted
        ..isFavorite = task.isFavorite
        ..isPendingSync = isPendingSync,
    );
  }

  Future<void> clearDB() async {
    final box = Hive.box('favouriteBox');
    if (box .isNotEmpty) {
      await box.clear();
    }

    final pendingDeletionsBox = Hive.box<String>('pendingDeletionsBox');
    if (pendingDeletionsBox.isNotEmpty) {
      await pendingDeletionsBox.clear();
    }
  }

  Future<void> closeDB() async {
    await Hive.close();
  }

  Future<void> deleteDB() async {
    await Hive.deleteBoxFromDisk('favouriteBox');
    await Hive.deleteBoxFromDisk('pendingDeletionsBox');
  }

  Future<void> resetDB() async {
    await clearDB();
    await deleteDB();
    await localDBInitialize();
  }
}
