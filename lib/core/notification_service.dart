import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final _androidInitSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  bool _initialized = false;
  final _iosInitSettings = const DarwinInitializationSettings();
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    debugPrint('Firebase fg - initialize');
    if (!_initialized) {
      final initializationSettings = InitializationSettings(
        iOS: _iosInitSettings,
        android: _androidInitSettings,
      );
      await _notificationPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
      _initialized = true;
    }
    debugPrint('Firebase fg - initialized');
  }

  @pragma('vm:entry-point')
  static Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response,
  ) async {
    debugPrint('Firebase fg - onDidReceiveBackground $response');
    if (response.payload != null) {
      // saving last local noti on android that was click (background)
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setInt('last_local_notification_id', response.id ?? 0);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) async {
    debugPrint('Firebase fg - onDidReceiveNotification $response');
    if (response.payload != null) {
      // saving last local noti on android that was click (foreground)
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setInt('last_local_notification_id', response.id ?? 0);
    }
  }

  /// Show Heads Up Notification
  Future<void> showNotification({
    String? title,
    required String body,
    required int id,
    String? channelId,
    String? channelName,
    String? largeIcon,
    String? groupKey,
    String? payload,
  }) async {
    ByteArrayAndroidBitmap? androidBitmap;
    var androidNot = AndroidNotificationDetails(
      channelId ?? 'General Notifications',
      channelName ?? 'General Notifications',
      groupKey: groupKey,
      priority: Priority.max,
      importance: Importance.max,
      enableLights: true,
      largeIcon: androidBitmap,
    );

    var iosNot = const DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.active,
    );

    final platformNot = NotificationDetails(android: androidNot, iOS: iosNot);

    await _notificationPlugin.show(
      id,
      title,
      body,
      platformNot,
      payload: payload,
    );
  }

  /// Show Big Picture Notification
  Future<void> showBigPictureNotification({
    String? title,
    String? body,
    required String bigPictureUrl,
    int? id,
    String? groupKey,
    String? channelId,
    String? channelName,
    String? largeIconUrl,
    String? payload,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      channelId ?? 'General Notifications',
      channelName ?? 'General Notifications',
      groupKey: groupKey,
      priority: Priority.max,
      importance: Importance.max,
      enableLights: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationPlugin.show(
      id ?? 0,
      null,
      null,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show Big Picture Notification
  Future<void> showBigPictureNotificationWithNoSound({
    String? title,
    String? body,
    required String bigPictureUrl,
    int? id,
    String? groupKey,
    String? channelId,
    String? channelName,
    String? largeIconUrl,
    bool? enableVibration,
    String? payload,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      channelId ?? 'General Notifications',
      channelName ?? 'General Notifications',
      groupKey: groupKey,
      playSound: false,
      enableVibration: enableVibration ?? true,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationPlugin.show(
      id ?? 0,
      null,
      null,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show Notification With No Sound
  Future<void> showNotificationWithNoSound({
    String? title,
    required String body,
    int? id,
    String? channelId,
    String? channelName,
    String? largeIcon,
    String? groupKey,
    bool? enableVibration,
    String? payload,
  }) async {
    ByteArrayAndroidBitmap? androidBitmap;

    if (largeIcon != null) {}

    var androidNot = AndroidNotificationDetails(
      channelId ?? 'General Notifications',
      channelName ?? 'General Notifications',
      groupKey: groupKey,
      playSound: false,
      enableVibration: enableVibration ?? true,
      largeIcon: androidBitmap,
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var iosNot = const DarwinNotificationDetails(presentSound: false);

    final platformNot = NotificationDetails(android: androidNot, iOS: iosNot);

    await _notificationPlugin.show(
      id ?? 0,
      title,
      body,
      platformNot,
      payload: payload,
    );
  }

  /// Cancel Notification With ID
  Future<void> cancelNotification(int id) async {
    await _notificationPlugin.cancel(id);
  }

  /// Cancel Notification With ID and Tag
  Future<void> cancelNotificationWithTag(int id, String tag) async {
    await _notificationPlugin.cancel(id, tag: tag);
  }

  /// Cancel All Notification
  Future<void> cancelAllNotification() async {
    await _notificationPlugin.cancelAll();
  }
}
