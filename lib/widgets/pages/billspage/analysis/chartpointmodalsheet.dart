import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/billingtile.dart';

class ChartPointModalSheet extends StatelessWidget {
  final List<BillModel> bills;
  late double totalAmount = 0;

  ChartPointModalSheet({Key? key, required this.bills}) : super(key: key) {
    for (var bill in bills) {
      totalAmount += bill.amount!;
    }
  }

  Padding heading(DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 15),
      child: Text(
        "Rechnungen vom ${date.day}.${date.month}.${date.year}",
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  Padding total() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 15),
      child: Text(
        "Total: ${totalAmount.toStringAsFixed(2)} €",
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> children() {
    var list = <Widget>[heading(bills.first.date!), total()];

    for (var bill in bills) {
      list.add(BillingTile(bill: bill));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children(),
        ),
      ),
    );
  }
}
