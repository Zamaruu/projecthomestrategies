import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillbuilder.dart';
import 'package:provider/provider.dart';

class BillingTile extends StatelessWidget {
  final BillModel bill;
  final bool showMenu;
  final Function? onTap;

  const BillingTile({
    Key? key,
    required this.bill,
    this.showMenu = false,
    this.onTap,
  }) : super(key: key);

  Future editBill(BuildContext ctx) async {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditBillBuilder(
          billId: bill.billId!,
          categories: ctx.read<BillingState>().billCategories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap == null && showMenu
              ? () => editBill(context)
              : () => onTap!(),
          leading: Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 200),
            child: Text(
              "${bill.amount!.toStringAsFixed(2)} €",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            "Bezahlt für ${bill.category!.billCategoryName!}",
          ),
          subtitle: RichText(
            text: TextSpan(
              text: 'am ${Global.datetimeToDeString(bill.date!)} von ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: bill.buyer!.email!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bill.buyer!.color!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
