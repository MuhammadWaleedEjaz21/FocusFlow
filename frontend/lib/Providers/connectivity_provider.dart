import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Providers/localdb_provider.dart';

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
  final previousOnline = ref.read(_previousOnlineStateProvider);

  Future.microtask(() {
    ref.read(_previousOnlineStateProvider.notifier).state = currentOnline;
  });

  if (previousOnline == false && currentOnline == true) {
    Future.microtask(() {
      final localDBController = ref.read(localDBProvider.future);
      localDBController.then((controller) {
        controller.syncFavourites();
      });
      ref.invalidateSelf();
    });
  }

  return currentOnline;
});
