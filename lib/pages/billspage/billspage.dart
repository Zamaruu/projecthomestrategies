import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/billspage/billingtimesection.dart';
import 'package:projecthomestrategies/widgets/billspage/billsspeeddial.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class MountBillProvider extends StatelessWidget {
  const MountBillProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BillingState(<BillCategoryModel>[], <BillModel>[]),
      child: const BillContentBuilder(),
    );
  }
}

class BillContentBuilder extends StatelessWidget {
  const BillContentBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingState>(
      builder: (context, state, _) {
        if (!state.isEmpty()) {
          return BillsPage();
        } else {
          return Consumer<AuthenticationState>(
            builder: (context, auth, child) {
              return FutureBuilder(
                future: BillingService(auth.token).getBillsAndCategories(
                    auth.sessionUser.household!.householdId!),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                  if (snapshot.hasError || snapshot.data!.hasError!) {
                    var error = snapshot.hasError
                        ? snapshot.error.toString
                        : snapshot.data!.message;
                    return ErrorPageHandler(error: error as String);
                  } else {
                    var bills = snapshot.data!["bills"];
                    var categories = snapshot.data!["categories"];

                    state.setInitialData(categories, bills);
                    return BillsPage();
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class BillsPage extends StatelessWidget {
  late List<BillModel> bills;

  BillsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Rechnungen",
      fab: const BillsSpeedDial(),
      body: ListView(
        children: [
          BillRetrospect.withSampleData(),
          // BillingTimeSection(label: "Diese Woche", bills: bills),
          // BillingTimeSection(label: "Letzte Woche", bills: bills),
          // BillingTimeSection(label: "Vorherige", bills: bills),
        ],
      ),
    );
  }
}
