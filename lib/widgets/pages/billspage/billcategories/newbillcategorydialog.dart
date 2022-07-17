import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/service/messenger_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/somesrategiesloadingbuilder.dart';
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
  late FocusNode nameFocusNode;

  @override
  void initState() {
    isLoading = false;
    nameFocusNode = FocusNode();
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

  Future<void> createNewCategory(UserModel user, String token) async {
    if (!newCategoryIsValid()) {
      return;
    }
    toggleLoading(true);

    try {
      var name = nameController.text.trim();
      var household = user.household!;
      BillCategoryModel newCategory = BillCategoryModel(
        billCategoryName: name,
        household: household,
      );

      var result =
          await BillingService(token).createBillingCategory(newCategory);

      toggleLoading(false);
      Navigator.pop(context, result);
    } catch (e) {
      print(e);
      // toggleLoading(false);
      // Navigator.pop(context);
      // InAppMessengerService(
      //   context,
      //   message: e.toString(),
      //   backgroundColor: Colors.orange,
      // );
    }
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
          focusNode: nameFocusNode,
          controller: nameController,
          type: TextInputType.text,
          maxChars: 30,
        ),
      ),
      actions: [
        CancelButton(onCancel: () => Navigator.of(context).pop()),
        Consumer<FirebaseAuthenticationState>(
          builder: (context, state, _) {
            return FutureBuilder<String>(
              future: Global.getToken(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return PrimaryButton(
                    onPressed: () => createNewCategory(
                      state.sessionUser,
                      snapshot.data!,
                    ),
                    text: "Lädt...",
                    icon: Icons.sync,
                  );
                } else {
                  return PrimaryButton(
                    onPressed: () => createNewCategory(
                      state.sessionUser,
                      snapshot.data!,
                    ),
                    text: "Erstellen",
                    icon: Icons.add,
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
