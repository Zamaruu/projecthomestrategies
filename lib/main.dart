import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme().customTheme,
      home: const Homepage(),
    );
  }
}