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

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) => {
              if (message != null)
                {
                  debugPrint("onStart Message received!"),
                  _navigateToNotificationRouteDestination(message)
                }
            });

    /// Function that will be called when a forground-notification is received in
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onForeground Message recieved!");
      debugPrint(message.notification!.body);
      LocalNotificationBuilder(navigatorKey)
          .createLocalFcmNotification(message);
    });

    /// Function that will be called when a background-notification is received
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('onBackground Message clicked!');

      _navigateToNotificationRouteDestination(message);
    });
  }

  void _navigateToNotificationRouteDestination(RemoteMessage message) {
    var serviceHandler = NotificationServiceHandler(navigatorKey);
    var route = serviceHandler.getRouteFromData(message.data["route"]);

    debugPrint(route.toString());

    if (route != null) {
      serviceHandler.navigateBasedOnRoute(route);
    }
  }
}
