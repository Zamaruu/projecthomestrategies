import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/appbar/customappbar.dart';
import 'package:projecthomestrategies/widgets/drawermenu/drawer.dart';

class BaseScaffold extends StatelessWidget {
  final String pageTitle;
  final bool showActions;
  final bool showNotification;
  final bool showMenuDrawer;
  final Widget body;
  final Widget? trailing;
  final Widget? fab;
  final Widget? bottomNavigationBar;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  BaseScaffold({
    Key? key,
    required this.pageTitle,
    required this.body,
    this.showActions = true,
    this.showMenuDrawer = true,
    this.fab,
    this.bottomNavigationBar,
    this.showNotification = false,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: pageTitle,
        trailling: trailing,
        showNotifications: showNotification,
        scaffoldKey: _scaffoldKey,
        showActions: showActions,
      ),
      endDrawer: showMenuDrawer ? const MenuDrawer() : null,
      body: body,
      floatingActionButton: fab,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
