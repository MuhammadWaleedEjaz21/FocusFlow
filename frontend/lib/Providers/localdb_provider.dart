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

    ref.invalidate(tasksListProvider(task.userEmail));
  }

  Future<void> removeFromFavourites(TaskModel task) async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.removeFromFavourites(task);

    ref.invalidate(tasksListProvider(task.userEmail));
  }

  Future<void> syncFavourites() async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.syncFavourites();
    final userEmail = await ref
        .read(prefProvider.future)
        .then((prefs) => prefs.getString('userEmail') ?? '');
    ref.invalidate(tasksListProvider(userEmail));
  }

  Future<void> clearFavourites() async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.clearDB();
  }

  Future<void> closeDB() async {
    final localDBService = ref.read(localDBServiceProvider);
    await localDBService.closeDB();
  }
}
