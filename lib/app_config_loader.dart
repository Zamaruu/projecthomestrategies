import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class AppConfigLoader extends StatefulWidget {
  const AppConfigLoader({Key? key}) : super(key: key);

  @override
  State<AppConfigLoader> createState() => _AppConfigLoaderState();
}

class _AppConfigLoaderState extends State<AppConfigLoader> {
  late FirebaseMessaging _firebaseMessaging;

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
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      debugPrint("message recieved");
      debugPrint(event.notification!.body);
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
