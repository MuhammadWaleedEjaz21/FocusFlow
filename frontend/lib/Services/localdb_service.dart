import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/localdb.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> localDBInitialize() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LocalDBAdapter());
  try {
    await Hive.openBox('favouriteBox');
  } catch (e) {
    await Hive.deleteBoxFromDisk('favouriteBox');
    await Hive.openBox('favouriteBox');
  }
}

class LocaldbService {
  Ref ref;
  LocaldbService(this.ref);
  Future<void> addtoFavourites(TaskModel task) async {
    final box = Hive.box('favouriteBox');

    // Add to local DB
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
    print("✓ Added to favourites in local DB");

    // Update on server
    try {
      await ref
          .read(taskProvider.future)
          .then(
            (controller) =>
                controller.updateTask(task.copyWith(isFavorite: true)),
          );
      print("✓ Updated favourite status on server");
    } catch (e) {
      print("✗ Error updating favourite on server: $e");
    }
  }

  Future<void> removeFromFavourites(TaskModel task) async {
    final box = Hive.box('favouriteBox');

    // Remove from local DB
    await box.delete(task.uniqueId);
    print("✓ Removed from favourites in local DB");

    // Update on server
    try {
      await ref
          .read(taskProvider.future)
          .then(
            (controller) =>
                controller.updateTask(task.copyWith(isFavorite: false)),
          );
      print("✓ Updated favourite status on server");
    } catch (e) {
      print("✗ Error updating favourite on server: $e");
    }
  }

  Future<List<TaskModel>> getFavourites() async {
    final box = Hive.box('favouriteBox');
    return box.values
        .cast<LocalDB>()
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
    final box = Hive.box('favouriteBox');
    final favourites = box.values
        .cast<LocalDB>()
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
    final currentUserEmail = await ref
        .read(prefProvider.future)
        .then((prefs) => prefs.getString('userEmail') ?? '');
    final taskList = await ref.read(tasksListProvider(currentUserEmail).future);
    for (var favTask in favourites) {
      final serverTask = taskList.firstWhere(
        (t) => t.uniqueId == favTask.uniqueId,
        orElse: () => favTask,
      );
      if (serverTask.isFavorite == false) {
        await ref
            .read(taskProvider.future)
            .then(
              (controller) => controller.updateTask(
                serverTask.copyWith(
                  title: favTask.title,
                  description: favTask.description,
                  isFavorite: true,
                  dueDate: favTask.dueDate,
                  category: favTask.category,
                  priority: favTask.priority,
                  isCompleted: favTask.isCompleted,
                ),
              ),
            );
      }
    }
  }

  Future<void> clearDB() async {
    final box = Hive.box('favouriteBox');
    await box.clear();
  }

  Future<void> closeDB() async {
    await Hive.close();
  }
}
