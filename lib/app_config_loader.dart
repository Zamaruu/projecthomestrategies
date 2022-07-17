import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projecthomestrategies/configure_services.dart';
import 'package:projecthomestrategies/pages/authpages/signinpage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/pages/homepage/initialloader.dart';
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
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  late ServiceConfiguration serviceConfiguration;

  @override
  void initState() {
    super.initState();
    serviceConfiguration = ServiceConfiguration(navigatorKey);
    serviceConfiguration.initializeFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Home Strategies',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      theme: context.watch<AppTheme>().customTheme,
      // initialRoute: '/auth',
      routes: Global.appRoutes,
      home: Consumer<User?>(
        builder: (context, user, _) {
          if (user != null) {
            return const InitialLoader();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
