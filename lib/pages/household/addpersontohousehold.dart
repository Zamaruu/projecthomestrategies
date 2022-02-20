import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/service/household_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:provider/provider.dart';

class AddUserToHousehold extends StatefulWidget {
  const AddUserToHousehold({Key? key}) : super(key: key);

  @override
  State<AddUserToHousehold> createState() => _AddUserToHouseholdState();
}

class _AddUserToHouseholdState extends State<AddUserToHousehold> {
  late bool isLoading;
  late TextEditingController emailController;
  late FocusNode emailFocusNode;

  @override
  void initState() {
    isLoading = false;
    emailFocusNode = FocusNode();
    emailController = TextEditingController();
    super.initState();
  }

  Future<void> tryGetUser(BuildContext ctx) async {
    var email = emailController.text.trim();
    if (Global.validateEmail(email)) {
      setState(() {
        isLoading = true;
      });

      var token = Global.getToken(ctx);
      var response =
          await HouseholdService(token).getUserToAddToHousehold(email);

      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Person Haushalt hinzufügen"),
      content: HomeStrategiesLoadingBuilder(
        isLoading: isLoading,
        isDialog: true,
        child: TextInputField(
          focusNode: emailFocusNode,
          controller: emailController,
          type: TextInputType.emailAddress,
          helperText: "Benutzer E-Mail",
        ),
      ),
      actions: [
        PrimaryButton(
          onPressed: () => tryGetUser(context),
          text: "Hinzufügen",
          icon: Icons.person_add,
        ),
      ],
    );
  }
}
