import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/signup_model.dart';
import 'package:projecthomestrategies/service/authentication_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/somesrategiesloadingbuilder.dart';
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

  late FocusNode nameFocusNode;
  late FocusNode surnameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode checkPasswordFocusNode;

  @override
  void initState() {
    isLoading = false;

    emailFocusNode = FocusNode();
    surnameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    checkPasswordFocusNode = FocusNode();

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
    setState(() {
      isLoading = true;
    });
    if (handleValidation() == 200) {
      var fcmToken = await FirebaseMessaging.instance.getToken();

      SignupModel signupModel = SignupModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        fcmToken: fcmToken,
        firstname: firstnameController.text.trim(),
        surname: surnameController.text.trim(),
      );

      var result =
          await AuthenticationService().signUpWithEmailAndPassword(signupModel);

      setState(() {
        isLoading = false;
      });

      if (result.statusCode == 201) {
        //Navigator.pushNamedAndRemoveUntil(ctx, "/auth", (route) => false);
        Navigator.pop(ctx);
        AuthenticationResponse(ctx, result.statusCode).showSnackbar();
      } else {
        AuthenticationResponse.response(ctx, result).showSnackbar();
      }
    } else {
      AuthenticationResponse(ctx, 600).showSnackbar();
    }
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
                              focusNode: nameFocusNode,
                              controller: firstnameController,
                              helperText: "Vorname",
                              type: TextInputType.text,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextInputField(
                              focusNode: surnameFocusNode,
                              controller: surnameController,
                              helperText: "Nachname",
                              type: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextInputField(
                        focusNode: emailFocusNode,
                        controller: emailController,
                        helperText: "E-Mail Adresse",
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextInputField(
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        helperText: "Passwort",
                        type: TextInputType.visiblePassword,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextInputField(
                        focusNode: checkPasswordFocusNode,
                        controller: checkPasswordController,
                        helperText: "Passwort wiederholen",
                        type: TextInputType.visiblePassword,
                      ),
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
