import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/notification_service.dart';
import 'package:hkcoin/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> initializeFirebaseService() async {
  debugPrint('Firebase -----initializeFirebaseService-----');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    debugPrint("Failed to initialize Firebase: $e");
  }

  var messaging = FirebaseMessaging.instance;

  await messaging.setAutoInitEnabled(true);

  var settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('Firebase -----User Granted Permission-----');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('Firebase -----User Granted Provisional Permission-----');
  } else {
    debugPrint('Firebase -----User Declined Permission-----');
    return;
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

  FirebaseMessaging.onMessage.listen(onMessage);

  var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    debugPrint('Firebase -----getInitialMessage----- $initialMessage');
    _handleMessage(initialMessage);
  }
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    debugPrint('Firebase -----FCM new token $token-----');
  });
  debugPrint('Firebase -----FirebaseService Initialized-----');

  try {
    var token = await messaging.getToken();
    debugPrint('Firebase -----FCM token $token-----');
    // ignore: empty_catches
  } catch (e) {}

  // check for tapping background message
  final notificationService = NotificationService();
  if (!notificationService.isInitialized) {
    await notificationService.initialize();
  }
}

@pragma('vm:entry-point')
void _handleMessage(RemoteMessage message) {
  debugPrint('Firebase -----_handleMessage----- ${message.toMap()}');
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  debugPrint('Firebase -----onBackgroundMessage-----');
  debugPrint('Firebase ${message.toMap()}');

  debugPrint("Handling a background message");

  if (Platform.isAndroid) {
    try {
      NotificationService().showNotification(
        body: message.data.toString(),
        id: message.hashCode,
      );
    } catch (e) {
      debugPrint('Firebase onMessage error: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> onMessage(RemoteMessage message) async {
  debugPrint('Firebase -----onMessage-----');
  debugPrint('Firebase ${message.toMap()}');
  debugPrint('Firebase Got a message whilst in the foreground!');

  if (Platform.isAndroid) {
    try {
      NotificationService().showNotification(
        body: message.data.toString(),
        id: message.hashCode,
      );
    } catch (e) {
      debugPrint('Firebase onMessage error: $e');
    }
  }
}
