import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/auth/submitfab.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Willkommen zurück,",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Melde dich an",
                  style: TextStyle(
                    fontSize: 33,
                  ),
                ),
                const SizedBox(height: 64,),
                TextInputField(controller: emailController, helperText: "E-Mail Adresse", type: TextInputType.emailAddress,),
                const SizedBox(height: 32,),
                TextInputField(controller: passwordController, helperText: "Passwort", type: TextInputType.visiblePassword),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextButton(onPressed: (){}, child: const Text("Noch kein Konto?")),
            ),
            SubmitFAB(onPressed: () {}, tooltip: "Anmelden", icon: Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}