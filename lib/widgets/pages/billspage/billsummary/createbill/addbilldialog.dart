import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/bloc/provider/new_bill_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/createbill/addbillimagesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/createbill/addbillinformationsection.dart';
import 'package:provider/provider.dart';

class AddBillModal extends StatefulWidget {
  final List<BillCategoryModel> billCategories;
  final BillingState state;

  const AddBillModal(
      {Key? key, required this.billCategories, required this.state})
      : super(key: key);

  @override
  State<AddBillModal> createState() => _AddBillModalState();
}

class _AddBillModalState extends State<AddBillModal> {
  void toggleLoading(bool newValue, BuildContext ctx, LoadingSnackbar loader) {
    ctx.read<NewBillState>().setLoading(newValue);
    if (newValue) {
      loader.showLoadingSnackbar();
    } else {
      loader.dismissSnackbar();
    }
  }

  bool validateBillData(BuildContext ctx) {
    if (ctx.read<NewBillState>().moneySumController.text.isEmpty) {
      return false;
    }
    if (double.tryParse(
            ctx.read<NewBillState>().moneySumController.text.trim()) ==
        null) {
      return false;
    } else if (double.tryParse(
            ctx.read<NewBillState>().moneySumController.text.trim())! <=
        0) {
      return false;
    }
    if (ctx
        .read<NewBillState>()
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
        ctx.read<NewBillState>().moneySumController.text.trim());
    var category =
        widget.billCategories[ctx.read<NewBillState>().categorySelection];
    var date = ctx.read<NewBillState>().selectedDate;
    var description =
        ctx.read<NewBillState>().descriptionController.text.trim();
    var images = ctx
        .read<NewBillState>()
        .images
        .map((i) => BillImageModel(billImageId: 0, image: i))
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
      widget.state.addBill(response.object as BillModel);
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
    return ChangeNotifierProvider(
      create: (context) => NewBillState(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            title: const Text("Rechnung erstellen"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              NewBillInformationSection(
                billCategories: widget.billCategories,
              ),
              const NewBillImageSection(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey.shade400),
              ),
            ),
            height: kBottomNavigationBarHeight,
            child: Selector<NewBillState, bool>(
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
                      onPressed:
                          isLoading ? null : () => _createNewBill(context),
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
      },
    );
  }
}
