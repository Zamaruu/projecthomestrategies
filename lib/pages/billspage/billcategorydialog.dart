import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/billcategorylist.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/newbillcategorydialog.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<BillingState, List<BillCategoryModel>>(
        selector: (context, model) => model.billCategories,
        builder: (context, categories, _) {
          return BillCategoryList(billCategories: categories);
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
