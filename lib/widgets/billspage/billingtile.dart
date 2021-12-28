import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class BillingTile extends StatelessWidget {
  final BillModel bill;

  const BillingTile({ Key? key, required this.bill }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListTile(
        onTap: (){},
        leading: Text(
          "${bill.billSum.toStringAsFixed(2)} €",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text(
          "Bezahlt für ${bill.category}",
        ),
        subtitle: Text(
          "bezahlt am ${Global.datetimeToDeString(bill.billDate)} von ${bill.person}"
        ),
      ),
    );
  }
}