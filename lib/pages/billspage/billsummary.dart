import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/widgets/billspage/addbillmodal.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';
import 'package:provider/provider.dart';

class BillsSummary extends StatelessWidget {
  const BillsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BillRetrospect.withSampleData(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext ctx) {
            var billCategories = context.read<BillingState>().billCategories;
            return AddBillModal(
              billCategories: billCategories,
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
