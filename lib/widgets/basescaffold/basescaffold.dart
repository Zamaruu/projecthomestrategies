import 'package:blobs/blobs.dart';
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
  final FloatingActionButtonLocation fabLocation;

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
    this.fabLocation = FloatingActionButtonLocation.endFloat,
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
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: -200,
              //right: -20,
              left: -60,
              child: Blob.fromID(
                id: const ['17-8-8991'],
                size: 500,
                styles: BlobStyles(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            body,
          ],
        ),
      ),
      floatingActionButtonLocation: fabLocation,
      floatingActionButton: fab,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
