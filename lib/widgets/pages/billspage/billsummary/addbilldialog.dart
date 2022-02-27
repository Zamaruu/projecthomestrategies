import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/bloc/provider/new_bill_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/addbillimagesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/addbillinformationsection.dart';
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
  late bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  void toggleLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
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
    if (!validateBillData(ctx)) {
      return;
    }
    toggleLoading(true);

    var token = ctx.read<AuthenticationState>().token;

    var user = ctx.read<AuthenticationState>().sessionUser;
    var amount = double.tryParse(
        ctx.read<NewBillState>().moneySumController.text.trim());
    var category =
        widget.billCategories[ctx.read<NewBillState>().categorySelection];
    var date = ctx.read<NewBillState>().selectedDate;

    BillModel newBill = BillModel(
      amount: amount,
      category: category,
      date: date,
      buyer: user,
      household: user.household!,
    );

    var response = await BillingService(token).createNewBill(newBill);
    toggleLoading(false);
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
            title: const Text("Rechnung erstellen"),
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  NewBillInformationSection(
                    billCategories: widget.billCategories,
                  ),
                  const NewBillImageSection(),
                ],
              ),
              Positioned(
                bottom: 3,
                right: 8,
                child: Row(
                  children: [
                    CancelButton(onCancel: () => Navigator.of(context).pop()),
                    PrimaryButton(
                      onPressed: () => _createNewBill(context),
                      text: "Erstellen",
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
