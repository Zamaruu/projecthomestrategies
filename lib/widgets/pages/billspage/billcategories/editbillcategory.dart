import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:provider/provider.dart';

class EditCategoryDialog extends StatefulWidget {
  final BillCategoryModel catgeory;

  const EditCategoryDialog({Key? key, required this.catgeory})
      : super(key: key);

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late bool isLoading;
  late TextEditingController nameController;

  @override
  void initState() {
    isLoading = false;
    nameController = TextEditingController(
      text: widget.catgeory.billCategoryName,
    );
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
    } else if (newCategory == widget.catgeory.billCategoryName) {
      return false;
    }
    return true;
  }

  Future<void> handleEditCatgeory(BuildContext context) async {
    if (!newCategoryIsValid()) {
      return;
    }
    toggleLoading(true);

    widget.catgeory.billCategoryName = nameController.text.trim();

    var token = context.read<AuthenticationState>().token;
    var result =
        await BillingService(token).editBillingCategory(widget.catgeory);

    toggleLoading(true);
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Kategorie bearbeiten"),
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
          onPressed: () => handleEditCatgeory(context),
          text: "Speichern",
          icon: Icons.edit,
        ),
      ],
    );
  }
}
