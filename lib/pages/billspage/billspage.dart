import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/billspage/billingtimesection.dart';
import 'package:projecthomestrategies/widgets/billspage/billsspeeddial.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';
import 'dart:math';

// ignore: must_be_immutable
class BillsPage extends StatelessWidget {
  late List<BillModel> bills;

  BillsPage({Key? key}) : super(key: key) {
    bills = List.generate(
        4,
        (index) => BillModel(
              index,
              Random().nextInt(100).toDouble(),
              DateTime.now().toLocal(),
              "Maximilian Ditz",
              "Lebensmittel",
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Rechnungen",
      fab: const BillsSpeedDial(),
      body: ListView(
        children: [
          BillRetrospect.withSampleData(),
          BillingTimeSection(label: "Diese Woche", bills: bills),
          BillingTimeSection(label: "Letzte Woche", bills: bills),
          BillingTimeSection(label: "Vorherige", bills: bills),
        ],
      ),
    );
  }
}
