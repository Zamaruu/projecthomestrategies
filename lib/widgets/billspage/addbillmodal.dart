import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
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
  late TextEditingController moneySumController;
  late TextEditingController selectedDateController;
  late int categorySelection;
  late DateTime selectedDate;

  @override
  void initState() {
    isLoading = false;
    moneySumController = TextEditingController();
    categorySelection = 0;
    selectedDate = DateTime.now().toLocal();
    selectedDateController = TextEditingController();
    selectedDateController.text = Global.datetimeToDeString(selectedDate);
    super.initState();
  }

  void toggleLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  bool validateBillData() {
    if (moneySumController.text.isEmpty) {
      return false;
    }
    if (double.tryParse(moneySumController.text.trim()) == null) {
      return false;
    } else if (double.tryParse(moneySumController.text.trim())! <= 0) {
      return false;
    }
    if (selectedDate.isAfter(DateTime.now().toLocal())) {
      return false;
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("de", "DE"),
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateController.text = Global.datetimeToDeString(picked);
      });
    }
  }

  Future<void> _createNewBill(BuildContext ctx) async {
    if (!validateBillData()) {
      return;
    }
    toggleLoading(true);

    var token = ctx.read<AuthenticationState>().token;

    var user = ctx.read<AuthenticationState>().sessionUser;
    var amount = double.tryParse(moneySumController.text.trim());
    var category = widget.billCategories[categorySelection];
    var date = selectedDate;

    BillModel newBill = BillModel(
      amount: amount,
      category: category,
      date: date,
      buyer: user,
      household: user.household!,
    );

    var response = await BillingService(token).createNewBill(newBill);
    toggleLoading(true);
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
    return AlertDialog(
      title: const Text("Rechnung erstellen"),
      content: HomeStrategiesLoadingBuilder(
        isLoading: isLoading,
        isDialog: true,
        height: 200,
        child: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: moneySumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Rechnungsbetrag (in €)"),
                  hintText: "12.34 €",
                ),
              ),
              DropdownButton<int>(
                value: categorySelection,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Theme.of(context).primaryColor),
                underline: Container(
                  height: 2,
                  color: Theme.of(context).primaryColor,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    categorySelection = newValue!;
                  });
                },
                items: List.generate(
                  widget.billCategories.length,
                  (index) => DropdownMenuItem<int>(
                    value: index,
                    child: Text(widget.billCategories[index].billCategoryName!),
                  ),
                ),
              ),
              TextFormField(
                onTap: () => _selectDate(context),
                controller: selectedDateController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  label: Text("Rechnungsdatum"),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        CancelButton(onCancel: () => Navigator.of(context).pop()),
        PrimaryButton(
            onPressed: () => _createNewBill(context),
            text: "Erstellen",
            icon: Icons.add)
      ],
    );
  }
}
