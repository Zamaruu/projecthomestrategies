import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class MenuDrawerButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color color;

  const MenuDrawerButton(
      {Key? key, required this.scaffoldKey, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      splashRadius: Global.splashRadius,
      onPressed: () {
        scaffoldKey.currentState?.openEndDrawer();
      },
      icon: const Icon(Icons.menu),
    );
  }
}
