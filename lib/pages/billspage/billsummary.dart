import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/service/messenger_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/billingtimesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/createbill/addbilldialog.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/filterdialog/filterbuilder.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/lastmonthsummary.dart';
import 'package:provider/provider.dart';

class BillsSummary extends StatefulWidget {
  const BillsSummary({Key? key}) : super(key: key);

  @override
  State<BillsSummary> createState() => _BillsSummaryState();
}

class _BillsSummaryState extends State<BillsSummary> {
  late bool isLoading;
  late bool finalPageReached;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    finalPageReached = false;
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

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
    var token = await Global.getToken(ctx);
    var householdId = Global.getCurrentHousehold(ctx).householdId!;
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
      var billCategories = ctx.read<BillingState>().billCategories;
      var billState = ctx.read<BillingState>();

      Navigator.of(ctx).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddBillModal(
            billCategories: billCategories,
            state: billState,
          ),
        ),
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

  void filterBills(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const FilterBuilder(),
      ),
    );
  }

  Future<void> _loadMore(BuildContext ctx) async {
    if (finalPageReached) {
      ApiResponseHandlerService.custom(
        context: ctx,
        customMessage: "Es sind keine weiteren Rechnungen vorhanden!",
        statusCode: 500,
      ).showSnackbar();

      return;
    }

    var billState = ctx.read<BillingState>();

    setLoading(true);

    var page = billState.pageCount;
    var token = await Global.getToken(ctx);
    var household = Global.getCurrentHousehold(ctx);

    page = page + 1;

    var response = await BillingService(token).getBillsForHousehold(
      household.householdId!,
      pageNumber: page,
      pageSize: billState.pageSize,
    );

    setLoading(false);

    if (response.statusCode == 200) {
      var newBills = response.object as List<BillModel>;

      if (newBills.isNotEmpty) {
        billState.setPageCount(page);
        billState.addBills(newBills);
      }

      if (newBills.length < billState.pageSize) {
        setState(() {
          finalPageReached = true;
        });
      }
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
      backgroundColor: Colors.transparent,
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
                  if (getLastSevendays(model.bills).isNotEmpty)
                    BillingTimeSection(
                      label: "Letzten 7 Tage",
                      bills: getLastSevendays(model.bills),
                    ),
                  BillingTimeSection(
                    label: "Ältere Rechnungen",
                    bills: getOtherBills(model.bills),
                  ),
                  if (!isLoading && !finalPageReached)
                    TextButton(
                      onPressed: () => _loadMore(context),
                      child: const Text("Mehr laden..."),
                    ),
                  if (isLoading)
                    const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 45.0,
            height: 45.0,
            child: RawMaterialButton(
              fillColor: Theme.of(context).colorScheme.secondary,
              shape: const CircleBorder(),
              elevation: 0.0,
              child: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () => filterBills(context),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () => createBill(context),
            heroTag: null,
            tooltip: "Neue Rechnung erstellen",
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
