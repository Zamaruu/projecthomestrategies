import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/homepage/shoppinglist/shoppinglistpanel.dart';
import 'package:projecthomestrategies/widgets/homepage/tasks/pendingtaskspanel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showNotification: true,
      pageTitle: "Startseite",
      body: ListView(
        children: const [
          PendingTasksPanel(),
          ShoppinglistPanel(),
        ],
      ),
    );
  }
}
