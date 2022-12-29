import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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

Future<void> setUpRemoteConfigDefaultValues() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ),
  );

  await remoteConfig.setDefaults(const {
    // login page defaults
    "login_page_scaffold_title": "Login",
    "login_page_message":
        "Please log in to your account in order to interact with and create notes!",
    "login_page_email_hint": "Enter your email here",
    "login_page_password_hint": "Enter your password here",
    "login_page_login_button_text": "Login",
    "login_page_register_button_text": "Don't have an account? Register here!",
    "login_page_forgot_password_button_text": "I forgot my password",
    "login_page_user_not_found_error_message":
        "Cannot find a user with the entered credentials!",
    "login_page_wrong_password_error_message": "Wrong credentials",
    "login_page_generic_error_message": "Authentication error",
    // register page defaults
    "register_page_scaffold_title": "Register",
    "register_page_message":
        "Please register to create an account in order to interact with and create notes!",
    "register_page_email_hint": "Enter your email here",
    "register_page_password_hint": "Enter your password here",
    "register_page_register_button_text": "Register",
    "register_page_login_button_text": "Already have an account? Login here!",
    "register_page_email_already_in_use_error_message":
        "The email is already in use by another account!",
    "register_page_weak_password_error_message": "Weak password",
    "register_page_generic_error_message": "Failed to register",
    "register_page_invalid_email_error_message": "Invalid email",
    // forgot password page defaults
    "forgot_password_page_scaffold_title": "Forgot Password",
    "forgot_password_page_message":
        "If you forgot your password, simply enter your email and we will send you a password reset link.",
    "forgot_password_page_email_hint": "Enter your email here",
    "forgot_password_page_send_button_text": "Send me password reset link",
    "forgot_password_page_login_button_text": "Back to login page",
    "forgot_password_page_generic_error_message":
        "We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step.",
    // verify email page defaults
    "verify_email_page_scaffold_title": "Verify Email",
    "verify_email_page_message_1":
        "We've sent you an email verification. Please open it to verify your account.",
    "verify_email_page_message_2":
        "Do check the spam or junk email folders too.",
    "verify_email_page_message_3":
        "If you haven't received a verification email yet (even after checking in the spam and junk folders), press the button below",
    "verify_email_page_resend_button_text": "Resend verification email",
    "verify_email_page_restart_button_text": "Restart",
    // notes page defaults
    "notes_page_scaffold_title": "Your Notes",
    // notes list page defaults
    "notes_list_page_snackbar_action_text": "Close",
    // nav drawer widget defaults
    "nav_drawer_widget_title_web": "Menu",
    "nav_drawer_widget_tile_1_title_web": "Home",
    "nav_drawer_widget_tile_2_title_web": "Checked Notes",
    "nav_drawer_widget_tile_3_title_web": "Android App",
    "nav_drawer_widget_tile_4_title_web": "Feedback",
    "nav_drawer_widget_tile_5_title_web": "Contact Us",
    "nav_drawer_widget_tile_6_title_web": "Log out",
    "nav_drawer_widget_tile_3_ontap_uri_web":
        "https://play.google.com/store/apps/details?id=com.RajatShenoi.mynotes",
    "nav_drawer_widget_tile_4_ontap_uri_web":
        "https://docs.google.com/forms/d/e/1FAIpQLSe4AGFAF7RFtLjnnTrmr9ZYmda1DaI1E3Jo-MsGyGt1xbEe2A/viewform?usp=sf_link",
    "nav_drawer_widget_tile_5_ontap_uri_web":
        "mailto:developer.rajat.shenoi@gmail.com",
    "nav_drawer_widget_title_android": "Menu",
    "nav_drawer_widget_tile_1_title_android": "Home",
    "nav_drawer_widget_tile_2_title_android": "Checked Notes",
    "nav_drawer_widget_tile_3_title_android": "Feedback",
    "nav_drawer_widget_tile_4_title_android": "Contact Us",
    "nav_drawer_widget_tile_5_title_android": "Log out",
    "nav_drawer_widget_tile_3_ontap_uri_android":
        "https://docs.google.com/forms/d/e/1FAIpQLSe4AGFAF7RFtLjnnTrmr9ZYmda1DaI1E3Jo-MsGyGt1xbEe2A/viewform?usp=sf_link",
    "nav_drawer_widget_tile_4_ontap_uri_android":
        "mailto:developer.rajat.shenoi@gmail.com",
    // checked notes page defaults
    "checked_notes_page_scaffold_title": "Your Checked Notes",
  });

  await remoteConfig.fetchAndActivate();
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
