import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const HomeStrategies());
}

class HomeStrategies extends StatelessWidget {
  const HomeStrategies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppTheme(),),
        ChangeNotifierProvider(create: (context) => AuthenticationState(),)
      ], 
      child: const AppConfigLoader(),
    );
  }
}

class AppConfigLoader extends StatelessWidget {
  const AppConfigLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Strategies',
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
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