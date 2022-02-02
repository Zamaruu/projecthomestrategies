import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:provider/provider.dart';

class CreateBillCategoryDialog extends StatefulWidget {
  final List<String> existingCategories;

  const CreateBillCategoryDialog({Key? key, required this.existingCategories})
      : super(key: key);

  @override
  State<CreateBillCategoryDialog> createState() =>
      _CreateBillCategoryDialogState();
}

class _CreateBillCategoryDialogState extends State<CreateBillCategoryDialog> {
  late bool isLoading;
  late TextEditingController nameController;

  @override
  void initState() {
    isLoading = false;
    nameController = TextEditingController();
    super.initState();
  }

  void toggleLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  bool newCategoryIsValid() {
    var newCategory = nameController.text.trim();

    if (newCategory.isEmpty) {
      return false;
    } else if (widget.existingCategories.contains(newCategory)) {
      return false;
    }
    return true;
  }

  Future<void> createNewCategory(BuildContext ctx) async {
    if (!newCategoryIsValid()) {
      return;
    }
    toggleLoading(true);

    var name = nameController.text.trim();
    var household = ctx.read<AuthenticationState>().sessionUser.household!;
    BillCategoryModel newCategory = BillCategoryModel(
      billCategoryName: name,
      household: household,
    );

    var token = ctx.read<AuthenticationState>().token;
    var result = await BillingService(token).createBillingCategory(newCategory);

    toggleLoading(true);
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Neue Kategorie erstellen"),
      content: HomeStrategiesLoadingBuilder(
        isLoading: isLoading,
        isDialog: true,
        child: TextInputField(
          helperText: "Name",
          controller: nameController,
          type: TextInputType.text,
          maxChars: 30,
        ),
      ),
      actions: [
        CancelButton(onCancel: () => Navigator.of(context).pop()),
        PrimaryButton(
          onPressed: () => createNewCategory(context),
          text: "Erstellen",
          icon: Icons.add,
        ),
      ],
    );
  }
}
