import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/appbar/menudrawerbutton.dart';
import 'package:projecthomestrategies/widgets/appbar/notificationbutton.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showActions; 

  const CustomAppBar({ Key? key, required this.title, required this.scaffoldKey, required this.showActions }) : preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: ((){
        if(showActions){
          return [
            const NotificationButton(),
            MenuDrawerButton(scaffoldKey: scaffoldKey),
          ];
        }
      }()),
    );
  }
}