import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/billspage/billsspeeddial.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';

class BillsPage extends StatelessWidget {
  const BillsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Rechnungen",
      fab: const BillsSpeedDial(),
      body: ListView(
        children: [
          BillRetrospect.withSampleData(),
        ],
      ),
    );
  }
}