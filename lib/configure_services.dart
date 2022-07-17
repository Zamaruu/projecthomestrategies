import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/localnotificationbuilder.dart';

class ServiceConfiguration {
  final GlobalKey<NavigatorState> navigatorKey;

  ServiceConfiguration(this.navigatorKey);

  void initializeFirebaseMessaging() {
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint("FCM-Token: $value");
    });
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("message recieved");
      debugPrint(message.notification!.body);
      LocalNotificationBuilder(navigatorKey)
          .createLocalFcmNotification(message);
    });
    // FirebaseMessaging.onBackgroundMessage(
    //   onBackgroundHanlder,
    // );
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Message clicked!');

      var serviceHandler = NotificationServiceHandler(navigatorKey);
      var route = serviceHandler.getRouteFromData(message.data["route"]);

      debugPrint(route.toString());

      if (route != null) {
        serviceHandler.navigateBasedOnRoute(route);
      }
    });
  }
}
