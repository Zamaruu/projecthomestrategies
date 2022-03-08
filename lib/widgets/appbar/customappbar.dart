import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/appbar/menudrawerbutton.dart';
import 'package:projecthomestrategies/widgets/appbar/navigatebackbutton.dart';
import 'package:projecthomestrategies/widgets/appbar/notificationbutton.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showActions;
  final bool showNotifications;
  final Widget? trailling;
  final Color onAppBarColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
    required this.showActions,
    this.showNotifications = false,
    this.trailling,
    this.onAppBarColor = Colors.black,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Navigator.canPop(context)
          ? NavigateBackButton(color: onAppBarColor)
          : null,
      title: Text(
        title,
        style: TextStyle(color: onAppBarColor),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      actions: (() {
        if (showActions) {
          return <Widget>[
            if (showNotifications) NotificationButton(color: onAppBarColor),
            MenuDrawerButton(scaffoldKey: scaffoldKey, color: onAppBarColor),
          ];
        }
        if (trailling != null) {
          return <Widget>[
            trailling!,
          ];
        }
      }()),
    );
  }
}
