import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationBuilder {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late InitializationSettings _initializationSettings;

  LocalNotificationBuilder() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    _initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
  }

  Future<bool?> _initialize() async {
    return await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: (value) {
        debugPrint(value);
      },
    );
  }

  //Methods
  Future<void> createLocalFcmNotification(RemoteMessage fcmMessage) async {
    var initialized = await _initialize();
    if (initialized == null) {
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'System Notifizierungen',
      channelDescription: 'Kanal für Benachrichtigungen des Backends',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      fcmMessage.notification!.title,
      fcmMessage.notification!.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
