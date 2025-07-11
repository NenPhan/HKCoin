// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/notification_service.dart';
import 'package:hkcoin/firebase_options.dart';
import 'package:hkcoin/presentation.controllers/private_message_controller.dart';

Future<void> initializeFirebaseService() async {
  //log('Firebase -----initializeFirebaseService-----', name: "FIREBASE");
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    log("Failed to initialize Firebase: $e", name: "FIREBASE");
  }

  var messaging = FirebaseMessaging.instance;

  var settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //log('Firebase -----User Granted Permission-----', name: "FIREBASE");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log(
      'Firebase -----User Granted Provisional Permission-----',
      name: "FIREBASE",
    );
  } else {
    //log('Firebase -----User Declined Permission-----', name: "FIREBASE");
    return;
  }

  // try {
  //   var token = await messaging.getToken();
  //   log('Firebase FCM token $token', name: "FIREBASE");
  // } catch (e) {
  //   print(e);
  // }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var initMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initMessage != null) {
    _handleMessage(initMessage, true);
  }
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

  FirebaseMessaging.onMessage.listen(onMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    //log('Firebase -----FCM new token $token-----', name: "FIREBASE");
  });
  //log('Firebase -----FirebaseService Initialized-----', name: "FIREBASE");

  // check for tapping background message
  final notificationService = NotificationService();
  if (!notificationService.isInitialized) {
    await notificationService.initialize();
  }
}

void _handleMessage(RemoteMessage message, [bool isInit = false]) async {
  //log('Firebase -----_handleMessage----- ${message.toMap()}', name: "FIREBASE");

  NotificationService.handleClickNotification(jsonEncode(message.data), isInit);
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  //log('Firebase -----onBackgroundMessage-----', name: "FIREBASE");
  //log('Firebase ${message.toMap()}', name: "FIREBASE");

  Get.find<PrivateMessageController>().getPrivateMessageCount();
  if (Platform.isAndroid) {
    try {
      NotificationService().showNotification(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        id: message.hashCode,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      log('Firebase onMessage error: $e', name: "FIREBASE");
    }
  }
}

Future<void> onMessage(RemoteMessage message) async {
  //log('Firebase -----onMessage-----', name: "FIREBASE");
  //log('Firebase ${message.toMap()}', name: "FIREBASE");

  Get.find<PrivateMessageController>().getPrivateMessageCount();
  if (Platform.isAndroid) {
    try {
      NotificationService().showNotification(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        id: message.hashCode,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      log('Firebase onMessage error: $e', name: "FIREBASE");
    }
  }
}
