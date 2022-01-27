import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/billspage/addbillmodal.dart';
import 'package:projecthomestrategies/widgets/billspage/billingtimesection.dart';
import 'package:projecthomestrategies/widgets/billspage/lastmonthsummary.dart';
import 'package:provider/provider.dart';

class BillsSummary extends StatelessWidget {
  const BillsSummary({Key? key}) : super(key: key);

  List<BillModel> getLastSevendays(List<BillModel> bills) {
    bills = sortBillsAfterDate(bills);
    var now_1w = DateTime.now().subtract(const Duration(days: 7));
    return bills.where((element) => now_1w.isBefore(element.date!)).toList();
  }

  List<BillModel> getLastThirtyDays(List<BillModel> bills) {
    bills = sortBillsAfterDate(bills);
    var now_1w = DateTime.now().subtract(const Duration(days: 30));
    return bills.where((element) => now_1w.isBefore(element.date!)).toList();
  }

  List<BillModel> getOtherBills(List<BillModel> bills) {
    bills = sortBillsAfterDate(bills);
    var now_1w = DateTime.now().subtract(const Duration(days: 7));
    return bills.where((element) => now_1w.isAfter(element.date!)).toList();
  }

  List<BillModel> sortBillsAfterDate(List<BillModel> bills) {
    bills.sort((a, b) {
      var adate = a.date!; //before -> var adate = a.expiry;
      var bdate = b.date!; //before -> var bdate = b.expiry;
      return bdate.compareTo(
        adate,
      ); //to get the order other way just switch `adate & bdate`
    });

    return bills;
  }

  Future<void> refreshBills(BuildContext ctx) async {
    var token = ctx.read<AuthenticationState>().token;
    var householdId =
        ctx.read<AuthenticationState>().sessionUser.household!.householdId!;
    var response =
        await BillingService(token).getBillsForHousehold(householdId);

    if (response.statusCode == 200) {
      ctx.read<BillingState>().setBills(response.object as List<BillModel>);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<BillingState, List<BillModel>>(
        selector: (context, model) => model.bills,
        builder: (context, bills, child) {
          if (bills.isEmpty) {
            return const Center(
              child: Text("Keine Rechnungen vorhanden"),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshBills(context),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  LastMonthSummary(bills: bills),
                  BillingTimeSection(
                    label: "Letzten 7 Tage",
                    bills: getLastSevendays(bills),
                  ),
                  BillingTimeSection(
                    label: "Ältere Rechnungen",
                    bills: getOtherBills(bills),
                  ),
                ],
              ),
            );
          }
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
