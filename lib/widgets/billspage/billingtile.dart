import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class BillingTile extends StatelessWidget {
  final BillModel bill;

  const BillingTile({Key? key, required this.bill}) : super(key: key);

  PopupMenuButton billMenu(BuildContext ctx) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey.shade700,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text("Ändern"),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text("Löschen"),
          value: 2,
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          //editBillCategory(ctx);
        } else if (value == 2) {
          //deleteBillCategory(ctx);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListTile(
        onTap: () {},
        leading: Text(
          "${bill.amount!.toStringAsFixed(2)} €",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text(
          "Bezahlt für ${bill.category!.billCategoryName!}",
        ),
        subtitle: Text(
          "am ${Global.datetimeToDeString(bill.date!)} von ${bill.buyer!.email!}",
        ),
        trailing: billMenu(context),
      ),
    );
  }
}
