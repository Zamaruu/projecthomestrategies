import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/homepage/shoppinglist/shoppinglistpanel.dart';
import 'package:projecthomestrategies/widgets/homepage/tasks/pendingtaskspanel.dart';


class Homepage extends StatelessWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
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