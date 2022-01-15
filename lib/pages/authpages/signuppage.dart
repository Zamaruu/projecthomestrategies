import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/auth/submitfab.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController checkPasswordController;
  late TextEditingController firstnameController;
  late TextEditingController surnameController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    checkPasswordController = TextEditingController();
    firstnameController = TextEditingController();
    surnameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder:  (context, isKeyboardVisible){
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
                    const SizedBox(height: 40,),
                    Row(
                      children: [
                        Expanded(child: TextInputField(controller: passwordController, helperText: "Vorname", type: TextInputType.text)),
                        const SizedBox(width: 20,),
                        Expanded(child: TextInputField(controller: passwordController, helperText: "Nachname", type: TextInputType.text)),
                      ],
                    ),
                    const SizedBox(height: 32,),
                    TextInputField(controller: emailController, helperText: "E-Mail Adresse", type: TextInputType.emailAddress,),
                    const SizedBox(height: 32,),
                    TextInputField(controller: passwordController, helperText: "Passwort", type: TextInputType.visiblePassword),
                    const SizedBox(height: 32,),
                    TextInputField(controller: passwordController, helperText: "Passwort wiederholen", type: TextInputType.visiblePassword),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: !isKeyboardVisible? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Schon registriert?")),
                ),
                SubmitFAB(key: const Key("RegisterSubmit"), onPressed: () {}, tooltip: "Konto erstellen", icon: Icons.arrow_forward),
              ],
            ),
          )
          : null,
        );
      },
    );
  }
}