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
  try {
    await Hive.openBox<String>('pendingDeletionsBox');
  } catch (e) {
    await Hive.deleteBoxFromDisk('pendingDeletionsBox');
    await Hive.openBox<String>('pendingDeletionsBox');
  }
}

class LocaldbService {
  Ref ref;
  LocaldbService(this.ref);
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
    print("✓ Added to favourites in local DB");

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
    await box.delete(task.uniqueId);
    print("✓ Removed from favourites in local DB");

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
    final pendingDeletionsBox = Hive.box<String>('pendingDeletionsBox');
    final currentUserEmail = await ref
        .read(prefProvider.future)
        .then((prefs) => prefs.getString('userEmail') ?? '');
    final taskList = await ref.read(tasksListProvider(currentUserEmail).future);

    final pendingDeletions = pendingDeletionsBox.values.toList();
    for (var uniqueId in pendingDeletions) {
      final existsOnServer = taskList.any((t) => t.uniqueId == uniqueId);
      if (existsOnServer) {
        print("↑ Syncing offline deletion to server: $uniqueId");
        try {
          final taskToDelete = taskList.firstWhere(
            (t) => t.uniqueId == uniqueId,
          );
          await ref
              .read(taskProvider.future)
              .then((controller) => controller.deleteTask(taskToDelete));
        } catch (e) {
          print("✗ Error deleting task on server: $e");
        }
      }
    }
    await pendingDeletionsBox.clear();
    print("✓ Cleared pending deletions");

    final updatedTaskList = await ref.refresh(
      tasksListProvider(currentUserEmail).future,
    );

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

    for (var favTask in favourites) {
      final existsOnServer = updatedTaskList.any(
        (t) => t.uniqueId == favTask.uniqueId,
      );
      if (!existsOnServer) {
        print("↓ Removing task deleted from server: ${favTask.title}");
        await box.delete(favTask.uniqueId);
      } else {
        final serverTask = updatedTaskList.firstWhere(
          (t) => t.uniqueId == favTask.uniqueId,
        );
        if (serverTask.isFavorite == false) {
          print("↑ Updating existing task on server: ${favTask.title}");
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

    final currentFavourites = box.values
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

    final refreshedTaskList = await ref.refresh(
      tasksListProvider(currentUserEmail).future,
    );
    for (var favTask in currentFavourites) {
      final existsOnServer = refreshedTaskList.any(
        (t) => t.uniqueId == favTask.uniqueId,
      );
      if (!existsOnServer) {
        print("↑ Syncing new offline task to server: ${favTask.title}");
        await ref
            .read(taskProvider.future)
            .then((controller) => controller.addTask(favTask));
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
        ..isFavorite = true,
    );
    print("✓ Added local task to local DB");
  }

  Future<void> removeLocalTask(String uniqueId) async {
    final box = Hive.box('favouriteBox');
    await box.delete(uniqueId);
    print("✓ Removed local task from local DB");

    final pendingDeletionsBox = Hive.box<String>('pendingDeletionsBox');
    await pendingDeletionsBox.add(uniqueId);
    print("✓ Added to pending deletions for server sync");
  }

  Future<void> updateLocalTask(TaskModel task) async {
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
        ..isFavorite = task.isFavorite,
    );
    print("✓ Updated local task in local DB");
  }

  Future<void> clearDB() async {
    final box = Hive.box('favouriteBox');
    if (box.isEmpty) {
      print("✓ Local DB is already clear");
    } else {
      await box.clear();
      print("✓ Cleared local DB");
    }

    final pendingDeletionsBox = Hive.box<String>('pendingDeletionsBox');
    if (pendingDeletionsBox.isNotEmpty) {
      await pendingDeletionsBox.clear();
      print("✓ Cleared pending deletions");
    }
  }

  Future<void> closeDB() async {
    await Hive.close();
  }

  Future<void> deleteDB() async {
    await Hive.deleteBoxFromDisk('favouriteBox');
    await Hive.deleteBoxFromDisk('pendingDeletionsBox');
    print("✓ Deleted local DB from disk");
  }

  Future<void> resetDB() async {
    await clearDB();
    await deleteDB();
    await localDBInitialize();
    print("✓ Reset local DB");
  }
}
