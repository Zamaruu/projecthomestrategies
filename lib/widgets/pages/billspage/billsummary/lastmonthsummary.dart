import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';

// ignore: must_be_immutable
class LastMonthSummary extends StatelessWidget {
  final List<BillModel> bills;
  late double currentMonthAmount;
  late double previousMonthAmount;
  final Color textColor = Colors.black;

  LastMonthSummary({Key? key, required this.bills}) : super(key: key) {
    currentMonthAmount = getCurrentMonthAmount(bills);
    previousMonthAmount = getPreviousMonthAmount(bills);
  }

  List<BillModel> getBillsOfCurrentMonth(List<BillModel> bills) {
    var now = DateTime.now().toUtc();

    var monthStartDate = DateTime.utc(now.year, now.month, 1);
    return bills
        .where((element) => element.date!.isAfter(monthStartDate))
        .toList();
  }

  List<BillModel> getBillsOfPreviousMonth(List<BillModel> bills) {
    var now = DateTime.now().toUtc();
    var currentMonth = now.month;
    var previousMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    var previousMonthYear = currentMonth == 1 ? now.year - 1 : now.year;

    var previousMonthStart = DateTime.utc(previousMonthYear, previousMonth, 1);
    var previousMonthEnd = DateTime.utc(previousMonthYear, previousMonth, 31);

    return bills
        .where((element) =>
            element.date!.isAfter(previousMonthStart) &&
            element.date!.isBefore(previousMonthEnd))
        .toList();
  }

  double getCurrentMonthAmount(List<BillModel> bills) {
    var currentMonthBills = getBillsOfCurrentMonth(bills);
    double amount = 0;

    for (var bill in currentMonthBills) {
      amount += bill.amount!;
    }

    return amount;
  }

  double getPreviousMonthAmount(List<BillModel> bills) {
    var previousMonthBills = getBillsOfPreviousMonth(bills);
    double amount = 0;

    for (var bill in previousMonthBills) {
      amount += bill.amount!;
    }

    return amount;
  }

  bool isLastMonthAmountBigger() {
    return previousMonthAmount > currentMonthAmount;
  }

  BoxDecoration decoration(BuildContext ctx) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 4),
          blurRadius: 10,
          spreadRadius: 4,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 177,
      margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 5),
      padding: const EdgeInsets.all(20),
      decoration: decoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Dieser Monat",
                  style: TextStyle(
                    fontSize: 21,
                    color: textColor,
                  ),
                ),
                Text(
                  "${currentMonthAmount.toStringAsFixed(2)} €",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                Text(
                  "letzter Monat",
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                Text(
                  "${previousMonthAmount.toStringAsFixed(2)} €",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isLastMonthAmountBigger()
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: Colors.black,
                    size: 27.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
