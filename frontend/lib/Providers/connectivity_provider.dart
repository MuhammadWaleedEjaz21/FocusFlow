import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/user_provider.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final _previousOnlineStateProvider = StateProvider<bool?>((ref) => null);

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  final currentOnline = connectivity.maybeWhen(
    data: (results) => !results.contains(ConnectivityResult.none),
    orElse: () => true,
  );
  final isLoggedIn = ref.watch(isLoggedInProvider);
  final previousOnline = ref.read(_previousOnlineStateProvider);

  Future.microtask(() {
    ref.read(_previousOnlineStateProvider.notifier).state = currentOnline;
  });

  if (previousOnline == false && currentOnline == true && isLoggedIn) {
    Future.microtask(() async {
      try {
        final localDBController = await ref.read(localDBProvider.future);
        await localDBController.syncFavourites();
      } catch (e) {
        // Handle sync error if necessary
      }
      ref.invalidateSelf();
    });
  }

  return currentOnline;
});
