import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/appbar/menudrawerburron.dart';
import 'package:projecthomestrategies/widgets/appbar/notificationbutton.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({ Key? key, required this.title, required this.scaffoldKey }) : preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        const NotificationButton(),
        MenuDrawerButton(scaffoldKey: scaffoldKey),
      ],
    );
  }
}