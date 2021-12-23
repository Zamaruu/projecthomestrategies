import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return ChangeNotifierProvider(
      create: (context) => AppTheme(),
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
      title: 'Flutter Demo',
      theme: context.watch<AppTheme>().customTheme,
      home: const Homepage(),
    );
  }
}