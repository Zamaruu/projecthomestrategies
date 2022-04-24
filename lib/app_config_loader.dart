import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/localnotificationbuilder.dart';
import 'package:provider/provider.dart';

Future<void> onBackgroundHanlder(
  RemoteMessage message,
  GlobalKey<NavigatorState>? key,
) async {
  await Firebase.initializeApp();

  var serviceHandler = NotificationServiceHandler(key!);
  var route = serviceHandler.getRouteFromData(message.data["route"]);

  debugPrint(route.toString());

  if (route != null) {
    serviceHandler.navigateBasedOnRoute(route);
  }
}

class AppConfigLoader extends StatefulWidget {
  const AppConfigLoader({Key? key}) : super(key: key);

  @override
  State<AppConfigLoader> createState() => _AppConfigLoaderState();
}

class _AppConfigLoaderState extends State<AppConfigLoader> {
  late FirebaseMessaging _firebaseMessaging;
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((value) {
      debugPrint(value);
    });
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
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Home Strategies',
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('de', 'DE'),
      // ],
      theme: context.watch<AppTheme>().customTheme,
      initialRoute: '/auth',
      routes: Global.appRoutes,
      //home: const HomePage(),
    );
  }
}
