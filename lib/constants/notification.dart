import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel generalAndroidNotificationChannel =
    AndroidNotificationChannel(
  "general_notification",
  "General Notifications",
  importance: Importance.high,
  playSound: true,
);
