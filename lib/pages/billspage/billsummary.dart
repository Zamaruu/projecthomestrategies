import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/service/messenger_service.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/addbillmodal.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/billingtimesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/lastmonthsummary.dart';
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

  void createBill(BuildContext ctx) {
    var categoriesExist = ctx.read<BillingState>().billCategories.isNotEmpty;
    if (categoriesExist) {
      showDialog(
        context: ctx,
        builder: (BuildContext context) {
          var billCategories = ctx.read<BillingState>().billCategories;
          var billState = ctx.read<BillingState>();
          return AddBillModal(
            billCategories: billCategories,
            state: billState,
          );
        },
      );
    } else {
      InAppMessengerService(
        ctx,
        message:
            "Du musst erst Rechnungskategorien anlegen bevor du Rechnungen erstellen kannst.",
        backgroundColor: Colors.orange,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BillingState>(
        builder: (context, model, child) {
          if (model.bills.isEmpty) {
            return const Center(
              child: Text("Keine Rechnungen vorhanden"),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshBills(context),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  LastMonthSummary(bills: model.bills),
                  BillingTimeSection(
                    label: "Letzten 7 Tage",
                    bills: getLastSevendays(model.bills),
                  ),
                  BillingTimeSection(
                    label: "Ältere Rechnungen",
                    bills: getOtherBills(model.bills),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createBill(context),
        tooltip: "Neue Rechnung erstellen",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
