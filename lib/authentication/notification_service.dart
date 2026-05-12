import 'dart:convert';

import 'package:jobilee/rsc/log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ✅ FIX: Must be a TOP-LEVEL function (outside any class).
// Instance methods cannot be used as background message handlers because
// they are not accessible across Dart isolates.
// The @pragma annotation prevents tree-shaking in release builds.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase must be re-initialized in the background isolate.
  await Firebase.initializeApp();
  AppLog.info('Handling a background message: ${message.messageId}');
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final localNotifications = FlutterLocalNotificationsPlugin();

  void _firebaseMessagingHandler(RemoteMessage? message) {
    if (message == null) return;
    AppLog.info('Handling a message handler: ${message.messageId}');
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then(_firebaseMessagingHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingHandler);

    // ✅ Now correctly references the top-level function above
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/notification_icon',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initLocalNotification() async {
    const android = AndroidInitializationSettings('@drawable/notification_icon');
    const settings = InitializationSettings(android: android);

    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (json) {
        if (json == null) return;

        final message = RemoteMessage.fromMap(jsonDecode(json.payload!));
        _firebaseMessagingHandler(message);
      },
    );

    final platform = localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    AppLog.info('FM token: $token');
    await initPushNotification();
    await initLocalNotification();
  }
}