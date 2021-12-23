import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/appbar/customappbar.dart';
import 'package:projecthomestrategies/widgets/drawermenu/drawer.dart';

class BaseScaffold extends StatelessWidget {
  final String pageTitle;
  final Widget body;
  final _scaffoldKey = GlobalKey<ScaffoldState>();  

  BaseScaffold({Key? key, required this.body, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: pageTitle, scaffoldKey: _scaffoldKey,),
      endDrawer: const MenuDrawer(),
      body: body,
    );
  }
}