import 'dart:convert';

import 'package:jobilee/loading.dart';
import 'package:jobilee/rsc/log.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    AppLog.info('Handling a background message: ${message.messageId}');
  }

  void _firebaseMessagingHandler(RemoteMessage? message) {
    if (message == null) return null;

    AppLog.info('Handling a message handler: ${message.messageId}');
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(_firebaseMessagingHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingHandler);
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
        payload: jsonEncode(message.toMap())
      );
    });
  }

  Future initLocalNotification() async {
    const android = AndroidInitializationSettings('@drawable/notification_icon');
    const settings = InitializationSettings(android: android);

    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (json) {
        if (json == null) return null;

        final message = RemoteMessage.fromMap(jsonDecode(json.payload!));
        _firebaseMessagingHandler(message);
      },
    );

    final platform = localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!;
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
    initPushNotification();
    initLocalNotification();
  }
}
