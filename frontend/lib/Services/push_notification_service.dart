import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Providers/push_notifications_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  try {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  } catch (e) {
    print('Error initializing notifications: $e');
  }
}

void _onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) {
  print('Notification tapped: ${notificationResponse.payload}');
}

class PushNotificationService {
  final Ref ref;
  PushNotificationService(this.ref);
  final FlutterLocalNotificationsPlugin _plugin =
      _flutterLocalNotificationsPlugin;
  final String channelIdSoundOn = 'task_channel_sound_on';
  final String channelIdSoundOff = 'task_channel_sound_off';

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final isSoundOn = ref.watch(isSoundOnProvider);
    final isNotificationOn = ref.watch(isNotificationsInitializedProvider);
    if (isNotificationOn != true) {
      await cancelAllNotifications();
      return;
    } else {
      try {
        final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
        final AndroidNotificationDetails androidPlatformChannelSpecifics;
        if (isSoundOn) {
          androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channelIdSoundOn,
            'Task Notifications (Sound On)',
            channelDescription: 'Notifications for tasks with sound enabled',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          );
        } else {
          androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channelIdSoundOff,
            'Task Notifications (Sound Off)',
            channelDescription: 'Notifications for tasks with sound disabled',
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
          );
        }

        const DarwinNotificationDetails darwinNotificationDetails =
            DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
              presentBadge: true,
            );

        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(
              android: androidPlatformChannelSpecifics,
              iOS: darwinNotificationDetails,
            );

        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      } catch (e) {
        print('Error scheduling notification: $e');
        rethrow;
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (e) {
      print('Error cancelling notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }
}
