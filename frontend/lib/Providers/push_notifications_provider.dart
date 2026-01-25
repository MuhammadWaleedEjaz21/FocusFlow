import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Services/push_notification_service.dart';

final pushNotificationServiceProvider = Provider((ref) {
  return PushNotificationService(ref);
});
final StateProvider<bool> isNotificationsInitializedProvider =
    StateProvider<bool>((ref) => false);
final StateProvider<bool> isSoundOnProvider =
    StateProvider<bool>((ref) => true);
