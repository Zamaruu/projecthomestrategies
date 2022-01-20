import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/signup_model.dart';
import 'package:projecthomestrategies/service/authentication_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/auth/authenticationresponse.dart';
import 'package:projecthomestrategies/widgets/auth/submitfab.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late bool isLoading;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController checkPasswordController;
  late TextEditingController firstnameController;
  late TextEditingController surnameController;

  @override
  void initState() {
    isLoading = false;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    checkPasswordController = TextEditingController();
    firstnameController = TextEditingController();
    surnameController = TextEditingController();
    super.initState();
  }

  bool passwordIsValid() {
    var password = passwordController.text.trim();
    var checkPassword = checkPasswordController.text.trim();

    if (password.isEmpty || checkPassword.isEmpty) {
      return false;
    } else {
      return password == checkPassword;
    }
  }

  int handleValidation() {
    if (!passwordIsValid()) {
      return 600;
    }
    if (emailController.text.isEmpty) {
      return 600;
    }
    if (!Global.validateEmail(emailController.text.trim())) {
      return 600;
    }
    return 200;
  }

  Future handleSignUp(BuildContext ctx) async {
    int signUpResponse;

    setState(() {
      isLoading = true;
    });
    if (handleValidation() != 200) {
      signUpResponse = 600;
    }

    SignupModel signupModel = SignupModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      firstname: firstnameController.text.trim(),
      surname: surnameController.text.trim(),
    );

    signUpResponse =
        await AuthenticationService().signUpWithEmailAndPassword(signupModel);

    setState(() {
      isLoading = false;
    });

    AuthenticationResponse(ctx, signUpResponse).showSnackbar();
    //Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return HomeStrategiesLoadingBuilder(
      isLoading: isLoading,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Erstelle ein Konto!",
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextInputField(
                                  controller: firstnameController,
                                  helperText: "Vorname",
                                  type: TextInputType.text)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextInputField(
                                  controller: surnameController,
                                  helperText: "Nachname",
                                  type: TextInputType.text)),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextInputField(
                        controller: emailController,
                        helperText: "E-Mail Adresse",
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextInputField(
                          controller: passwordController,
                          helperText: "Passwort",
                          type: TextInputType.visiblePassword),
                      const SizedBox(
                        height: 32,
                      ),
                      TextInputField(
                          controller: checkPasswordController,
                          helperText: "Passwort wiederholen",
                          type: TextInputType.visiblePassword),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: !isKeyboardVisible
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Schon registriert?")),
                        ),
                        SubmitFAB(
                            key: const Key("RegisterSubmit"),
                            tag: "Register",
                            onPressed: () => handleSignUp(context),
                            tooltip: "Konto erstellen",
                            icon: Icons.person_add),
                      ],
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
