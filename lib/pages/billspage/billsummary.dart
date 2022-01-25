import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/widgets/billspage/addbillmodal.dart';
import 'package:projecthomestrategies/widgets/billspage/billingtile.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';
import 'package:provider/provider.dart';

class BillsSummary extends StatelessWidget {
  const BillsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<BillingState, List<BillModel>>(
        selector: (context, model) => model.bills,
        builder: (context, bills, child) {
          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (BuildContext context, int index) {
              return BillingTile(bill: bills[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext ctx) {
            var billCategories = context.read<BillingState>().billCategories;
            var billState = context.read<BillingState>();
            return AddBillModal(
              billCategories: billCategories,
              state: billState,
            );
          },
        ),
        tooltip: "Neue Rechnung erstellen",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
