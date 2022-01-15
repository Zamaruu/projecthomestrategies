import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/signuppage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/widgets/auth/submitfab.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:provider/provider.dart';

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

  void navigateToRegisterPage(BuildContext ctx){
    Navigator.of(ctx).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const SignUpPage(), 
      ),
    );
    // Navigator.of(ctx).pushNamed("/signup");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (context, auth, _){
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboadVisible){
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
              floatingActionButton: !isKeyboadVisible? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: TextButton(onPressed: () => navigateToRegisterPage(context), child: const Text("Noch kein Konto?")),
                    ),
                    SubmitFAB(
                      key: const Key("SignInSubmit"), 
                      onPressed: (){
                        auth.signIn(emailController.text.trim(), passwordController.text.trim());
                      },
                      tooltip: "Anmelden", 
                      icon: Icons.arrow_forward,
                    ),
                  ],
                ),
              )
              : null,
            );
          }
        );
      },
    );
  }
}