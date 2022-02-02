import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/localnotificationbuilder.dart';
import 'package:provider/provider.dart';

class AppConfigLoader extends StatefulWidget {
  const AppConfigLoader({Key? key}) : super(key: key);

  @override
  State<AppConfigLoader> createState() => _AppConfigLoaderState();
}

class _AppConfigLoaderState extends State<AppConfigLoader> {
  late FirebaseMessaging _firebaseMessaging;
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  Future<void> onBackgroundHanlder(RemoteMessage message) async {
    debugPrint(message.notification!.body);
  }

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
    //   (message) => onBackgroundHanlder(message),
    // );
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Message clicked!');
    });
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Home Strategies',
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [
        Locale('de'),
      ],
      theme: context.watch<AppTheme>().customTheme,
      initialRoute: '/auth',
      routes: Global.appRoutes,
      //home: const HomePage(),
    );
  }
}
