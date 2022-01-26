import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/widgets/billspage/billingtile.dart';

class ChartPointModalSheet extends StatelessWidget {
  final List<BillModel> bills;

  const ChartPointModalSheet({Key? key, required this.bills}) : super(key: key);

  Padding heading(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Text(
        "Rechnungen vom ${date.day}.${date.month}.${date.year}",
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  List<Widget> children() {
    var list = <Widget>[heading(bills.first.date!)];

    for (var bill in bills) {
      list.add(BillingTile(bill: bill));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children(),
    );
  }
}
