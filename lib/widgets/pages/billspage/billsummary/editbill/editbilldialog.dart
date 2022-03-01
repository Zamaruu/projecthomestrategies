import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillimagesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillinformationsection.dart';
import 'package:provider/provider.dart';

class EditBillDialog extends StatelessWidget {
  final List<BillCategoryModel> billCategories;

  const EditBillDialog({Key? key, required this.billCategories})
      : super(key: key);

  void toggleLoading(bool newValue, BuildContext ctx, LoadingSnackbar loader) {
    ctx.read<EditBillState>().setLoading(newValue);
    if (newValue) {
      loader.showLoadingSnackbar();
    } else {
      loader.dismissSnackbar();
    }
  }

  bool validateBillData(BuildContext ctx) {
    if (ctx.read<EditBillState>().moneySumController.text.isEmpty) {
      return false;
    }
    if (double.tryParse(
            ctx.read<EditBillState>().moneySumController.text.trim()) ==
        null) {
      return false;
    } else if (double.tryParse(
            ctx.read<EditBillState>().moneySumController.text.trim())! <=
        0) {
      return false;
    }
    if (ctx
        .read<EditBillState>()
        .selectedDate
        .isAfter(DateTime.now().toLocal())) {
      return false;
    }
    return true;
  }

  Future<void> _createNewBill(BuildContext ctx) async {
    LoadingSnackbar loader = LoadingSnackbar(ctx);

    if (!validateBillData(ctx)) {
      return;
    }

    toggleLoading(true, ctx, loader);

    var token = Global.getToken(ctx);

    var user = ctx.read<AuthenticationState>().sessionUser;
    var amount = double.tryParse(
        ctx.read<EditBillState>().moneySumController.text.trim());
    var category = billCategories[ctx.read<EditBillState>().categorySelection];
    var date = ctx.read<EditBillState>().selectedDate;
    var description =
        ctx.read<EditBillState>().descriptionController.text.trim();
    var images = ctx
        .read<EditBillState>()
        .images
        .map((i) => BillImageModel(billImageId: i.billImageId, image: i.image))
        .toList();

    BillModel newBill = BillModel(
      amount: amount,
      category: category,
      date: date,
      description: description,
      buyer: user,
      images: images,
      household: user.household!,
    );

    var response = await BillingService(token).createNewBill(newBill);

    toggleLoading(false, ctx, loader);

    if (response.statusCode == 200) {
      ctx.read<BillingState>().addBill(response.object as BillModel);
      Navigator.pop(ctx);
    } else {
      ApiResponseHandlerService(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rechnung bearbeiten"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          EditBillInformationSection(
            billCategories: billCategories,
          ),
          const EditBillImageSection(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey.shade400),
          ),
        ),
        height: kBottomNavigationBarHeight,
        child: Selector<EditBillState, bool>(
          selector: (context, model) => model.isLoading,
          builder: (context, isLoading, _) => Row(
            children: [
              SizedBox(
                height: kBottomNavigationBarHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton.icon(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    primary: Colors.grey.shade700,
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Abbrechen"),
                ),
              ),
              SizedBox(
                height: kBottomNavigationBarHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton.icon(
                  onPressed: isLoading ? null : () {},
                  style: TextButton.styleFrom(),
                  icon: const Icon(Icons.add),
                  label: const Text("Erstellen"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
