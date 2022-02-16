import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billcategories/billcategorytile.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billcategories/newbillcategorydialog.dart';
import 'package:provider/provider.dart';

class BillCategoriesDialog extends StatefulWidget {
  const BillCategoriesDialog({Key? key}) : super(key: key);

  @override
  _BillCategoriesDialogState createState() => _BillCategoriesDialogState();
}

class _BillCategoriesDialogState extends State<BillCategoriesDialog> {
  @override
  void initState() {
    super.initState();
  }

  List<String> getCategoryNames(List<BillCategoryModel> billCategories) {
    if (billCategories.isNotEmpty) {
      return List.generate(
        billCategories.length,
        (index) => billCategories[index].billCategoryName!,
      );
    } else {
      return <String>[];
    }
  }

  Future<void> createNewCategory(BuildContext ctx) async {
    var result = await showDialog<ApiResponseModel>(
      context: ctx,
      builder: (BuildContext context) {
        return CreateBillCategoryDialog(
          existingCategories: getCategoryNames(
            ctx.read<BillingState>().billCategories,
          ),
        );
      },
    );

    if (result != null) {
      if (result.statusCode == 200) {
        ctx
            .read<BillingState>()
            .addBillCategory(result.object as BillCategoryModel);
      } else {
        ApiResponseHandlerService(response: result, context: ctx)
            .showSnackbar();
      }
    }
  }

  Future<void> refreshBillCategories(BuildContext ctx) async {
    var token = Global.getToken(ctx);
    var householdId =
        ctx.read<AuthenticationState>().sessionUser.household!.householdId!;
    var response =
        await BillingService(token).getBillCategoriesForHousehold(householdId);

    if (response.statusCode == 200) {
      ctx
          .read<BillingState>()
          .setBillCategories(response.object as List<BillCategoryModel>);
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
      body: Consumer<BillingState>(
        builder: (context, state, _) {
          if (state.billCategories.isEmpty) {
            return const Center(
              child: Text("Keine Kategorien"),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshBillCategories(context),
              child: ListView.builder(
                itemCount: state.billCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  return BillCategoryTile(
                    billCategory: state.billCategories[index],
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewCategory(context),
        tooltip: "Neue Kategorie erstellen",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
