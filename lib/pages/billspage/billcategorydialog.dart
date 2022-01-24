import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/billcategorylist.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/newbillcategorydialog.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
import 'package:provider/provider.dart';

class BillCategoriesDialog extends StatefulWidget {
  final HouseholdModel householdModel;

  const BillCategoriesDialog({Key? key, required this.householdModel})
      : super(key: key);

  @override
  _BillCategoriesDialogState createState() => _BillCategoriesDialogState();
}

class _BillCategoriesDialogState extends State<BillCategoriesDialog> {
  late List<BillCategoryModel> billCategories;

  @override
  void initState() {
    super.initState();
  }

  List<String> getCategoryNames() {
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
          existingCategories: getCategoryNames(),
        );
      },
    );

    if (result != null) {
      if (result.statusCode == 200) {
        setState(() {});
      } else {
        ApiResponseHandlerService(response: result, context: ctx)
            .showSnackbar();
      }
    }
  }

  Future<ApiResponseModel> getCategories(BuildContext ctx) async {
    var token = ctx.read<AuthenticationState>().token;
    return await BillingService(token).getBillCategoriesForHousehold(
      widget.householdModel.householdId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategorien"),
      ),
      body: FutureBuilder<ApiResponseModel>(
        future: getCategories(context),
        builder: (
          BuildContext context,
          AsyncSnapshot<ApiResponseModel> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorPageHandler(error: snapshot.error.toString());
          } else {
            var response = snapshot.data!;
            if (response.statusCode == 200) {
              List<BillCategoryModel> categories = List<BillCategoryModel>.from(
                response.object.map(
                  (model) => BillCategoryModel.fromJson(model),
                ),
              );
              billCategories = categories;
              return BillCategoryList(billCategories: billCategories);
            } else {
              return ErrorPageHandler(error: response.message!);
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewCategory(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
