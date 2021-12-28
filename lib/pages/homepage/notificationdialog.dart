import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showActions: false,
      showMenuDrawer: false,
      pageTitle: "2 Benachrichtigungen",
      body: const Center(
        child: Text("Du hast keine Benachrichtigungen"),
      ), 
    );
  }
}