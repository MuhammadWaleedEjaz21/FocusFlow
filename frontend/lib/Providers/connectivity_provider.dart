import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  final currentOnline = connectivity.maybeWhen(
    data: (results) => !results.contains(ConnectivityResult.none),
    orElse: () => true,
  );

  return currentOnline;
});

final connectivityListenerProvider = Provider<void>((ref) {
  ref.listen<bool>(isOnlineProvider, (previous, current) {
    if (previous == false && current == true) {
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        Future.microtask(() async {
          try {
            final localDBController = await ref.read(localDBProvider.future);
            await localDBController.syncFavourites();
          } catch (e) {}
          final prefs = await ref.read(prefProvider.future);
          final userEmail = prefs.getString('userEmail') ?? '';
          ref.invalidate(tasksListProvider(userEmail));
          ref.invalidate(fetchlocalDB);
        });
      }
    }
  });
});
