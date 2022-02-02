import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';
import 'package:projecthomestrategies/pages/billspage/billspage.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class LocalNotificationBuilder {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late InitializationSettings _initializationSettings;
  final GlobalKey<NavigatorState> _navigatorState;

  //Constructor
  LocalNotificationBuilder(this._navigatorState) {
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

  //Methods
  Future<bool?> _initialize() async {
    return await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: (args) => onSelectNotification(args!),
    );
  }

  void onSelectNotification(String? args) {
    if (args == null) {
      return;
    } else {
      var body = jsonDecode(args);
      var route = NotificationServiceHandler.empty().getRouteFromData(
        body["route"],
      );

      if (route != null) {
        NotificationServiceHandler(_navigatorState).navigateBasedOnRoute(route);
      }
    }
  }

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
      payload: jsonEncode(fcmMessage.data),
    );
  }
}

class NotificationServiceHandler {
  late GlobalKey<NavigatorState> _navigatorState;

  NotificationServiceHandler.empty();
  NotificationServiceHandler(this._navigatorState);

  void navigateBasedOnRoute(NotificationRoute route) {
    switch (route) {
      case NotificationRoute.notification:
        debugPrint(route.toString());
        Global.navigateWithNavigatorKey(_navigatorState, "/notifications");
        break;
      case NotificationRoute.bills:
        debugPrint(route.toString());
        Global.navigateWithNavigatorKey(_navigatorState, "/bills");
        break;
      default:
        break;
    }
  }

  NotificationRoute? getRouteFromData(String source) {
    var rawRoute = int.tryParse(source);

    if (rawRoute != null) {
      var route = NotificationRoute.values[rawRoute];
      return route;
    }
    return null;
  }
}
