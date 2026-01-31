import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Services/localdb_service.dart';

final localDBServiceProvider = Provider<LocaldbService>((ref) {
  return LocaldbService(ref);
});

final fetchlocalDB = FutureProvider<List<TaskModel>>((ref) async {
  final localDBService = ref.read(localDBServiceProvider);
  return localDBService.getFavourites();
});

final localDBProvider = FutureProvider<LocalDBController>((ref) async {
  return LocalDBController(ref);
});

class LocalDBController {
  Ref ref;
  LocalDBController(this.ref);

  Future<void> addtoFavourites(TaskModel task) async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.addtoFavourites(task);
    ref.invalidate(fetchlocalDB);
    ref.invalidate(tasksListProvider(task.userEmail));
  }

  Future<void> removeFromFavourites(TaskModel task) async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.removeFromFavourites(task);
    ref.invalidate(fetchlocalDB);
    ref.invalidate(tasksListProvider(task.userEmail));
  }

  Future<void> syncFavourites() async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.syncFavourites();
    final userEmail = await ref
        .read(prefProvider.future)
        .then((prefs) => prefs.getString('userEmail') ?? '');
    // Invalidate both task lists and local DB to refresh UI
    ref.invalidate(tasksListProvider(userEmail));
    ref.invalidate(fetchlocalDB);
  }

  Future<void> clearFavourites() async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.clearDB();

    ref.invalidate(fetchlocalDB);
  }

  Future<void> closeDB() async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.closeDB();

    ref.invalidate(fetchlocalDB);
  }

  Future<void> addLocalTask(TaskModel task) async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.addLocalTask(task);
    ref.invalidate(fetchlocalDB);
  }

  Future<void> updateLocalTask(TaskModel task) async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.updateLocalTask(task);
    ref.invalidate(fetchlocalDB);
  }

  Future<void> deleteLocalTask(TaskModel task) async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.removeLocalTask(task.uniqueId);
    ref.invalidate(fetchlocalDB);
  }
}
