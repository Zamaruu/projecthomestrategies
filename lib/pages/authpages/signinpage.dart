import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/signuppage.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/securestoragehandler.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/auth/authenticationresponse.dart';
import 'package:projecthomestrategies/widgets/auth/staysignedincheckbox.dart';
import 'package:projecthomestrategies/widgets/auth/submitfab.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool staySignedIn;
  late bool isLoading;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    staySignedIn = false;
    isLoading = false;
    super.initState();
  }

  void navigateToRegisterPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const SignUpPage(),
      ),
    );
    // Navigator.of(ctx).pushNamed("/signup");
  }

  Future<ApiResponseModel> tryLogin(AuthenticationState authState) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (Global.validateEmail(emailController.text.trim())) {
        setState(() {
          isLoading = true;
        });

        return await authState.signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } else {
        return ApiResponseModel.error(
          601,
          "E-Mail ist nicht im korrekten Format!",
        );
      }
    } else {
      return ApiResponseModel.error(
        600,
        "Es müssen alle Felder ausgefüllt sein!",
      );
    }
  }

  Future handleSignIn(AuthenticationState auth, BuildContext ctx) async {
    var response = await tryLogin(auth);
    setState(() {
      isLoading = false;
    });

    if (staySignedIn && response.statusCode == 200) {
      await SecureStorageHandler().safeCredentials(
        Global.encodeCredentials(
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }

    if (response.statusCode != 200) {
      AuthenticationResponse.response(context, response).showSnackbar();
    }
  }

  void setSignedIn(bool newValue) {
    setState(() {
      staySignedIn = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeStrategiesLoadingBuilder(
      isLoading: isLoading,
      child: Consumer<AuthenticationState>(
        builder: (context, auth, _) {
          return KeyboardVisibilityBuilder(
            builder: (context, isKeyboadVisible) {
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
                          const SizedBox(
                            height: 64,
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
                          StaySignedInCheckBox(
                            staySignedIn: staySignedIn,
                            setSignedIn: setSignedIn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: !isKeyboadVisible
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: TextButton(
                                  onPressed: () =>
                                      navigateToRegisterPage(context),
                                  child: const Text("Noch kein Konto?")),
                            ),
                            SubmitFAB(
                              key: const Key("SignInSubmit"),
                              tag: "SignIn",
                              onPressed: () => handleSignIn(auth, context),
                              tooltip: "Anmelden",
                              icon: Icons.arrow_forward,
                            ),
                          ],
                        ),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
