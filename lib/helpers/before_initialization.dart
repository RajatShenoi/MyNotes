import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mynotes/constants/notification.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> checkAndPerformUpdates() async {
  try {
    InAppUpdate.checkForUpdate().then((updateInfo) => {
          if (updateInfo.updateAvailability ==
              UpdateAvailability.updateAvailable)
            {
              if (updateInfo.immediateUpdateAllowed)
                {
                  InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
                    if (appUpdateResult == AppUpdateResult.success) {
                      devtools.log("Update Successfull");
                    } else {
                      devtools.log("Update failed");
                    }
                  })
                }
            }
          else if (updateInfo.flexibleUpdateAllowed)
            {
              InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
                if (appUpdateResult == AppUpdateResult.success) {
                  InAppUpdate.completeFlexibleUpdate();
                }
              })
            }
        });
  } catch (e) {
    devtools.log(e.toString());
  }
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  if (DefaultFirebaseOptions.currentPlatform ==
      DefaultFirebaseOptions.android) {
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            generalAndroidNotificationChannel.id,
            generalAndroidNotificationChannel.name,
            color: Colors.purple,
            playSound: true,
            icon: "@mipmap/launcher_icon",
          )));
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  devtools.log("A bg message just showed up: ${message.messageId}");
  // showFlutterNotification(message);
}

Future<void> firebaseCloudMessagingBackground() async {
  try {
    late final token;
    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      token = await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BIh0Vo7S8RHIJTidDgzkydSWG89sLP67so39ULCmhisz-JxX4pkYroZ0uj6VoY6clFH59PlfKQbk1WRaMmw9r9k");
    } else {
      token = await FirebaseMessaging.instance.getToken();
    }
    devtools.log(token.toString());

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    devtools.log("Notification Permission: ${settings.authorizationStatus}");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    devtools.log(
        "We had trouble showing / setting up an 'onBackgroundMessage' notification.");
  }
  if (DefaultFirebaseOptions.currentPlatform ==
      DefaultFirebaseOptions.android) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalAndroidNotificationChannel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  try {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      devtools.log("A onMessage message just showed up: ${message.messageId}");
      // showFlutterNotification(message);
    });
  } catch (e) {
    devtools.log("We had trouble showing an 'onMessage' notification.");
  }
}
