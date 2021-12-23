import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class MenuDrawerButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MenuDrawerButton({ Key? key, required this.scaffoldKey }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: Global.splashRadius,
      onPressed: (){
        scaffoldKey.currentState?.openEndDrawer();
      }, 
      icon: const Icon(Icons.menu),
    );
  }
}