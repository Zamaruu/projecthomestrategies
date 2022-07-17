import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/signuppage.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/securestoragehandler.dart';
import 'package:projecthomestrategies/widgets/auth/registerblob.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/auth/authenticationresponse.dart';
import 'package:projecthomestrategies/widgets/auth/staysignedincheckbox.dart';
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
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
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

  Future<ApiResponseModel> tryLogin(
    FirebaseAuthenticationState authState,
    BuildContext ctx,
  ) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (Global.validateEmail(emailController.text.trim())) {
        setState(() {
          isLoading = true;
        });

        var result = await authState.signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        return ApiResponseModel.success(200, result);
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

  Future handleSignIn(
      FirebaseAuthenticationState auth, BuildContext ctx) async {
    var response = await tryLogin(auth, ctx);
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

  // Future handleTryAgainWithSavedCredentials(
  //     FirebaseAuthenticationState auth, BuildContext ctx) async {
  //   var credentials = await SecureStorageHandler().getLoggedInUserCredentials();

  //   if (credentials != null) {
  //     await auth.signInWithSavedCredentials(credentials, ctx);
  //   } else {
  //     return;
  //   }
  // }

  void setSignedIn(bool newValue) {
    setState(() {
      staySignedIn = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeStrategiesLoadingBuilder(
      isLoading: isLoading,
      child: Consumer<FirebaseAuthenticationState>(
        builder: (context, auth, _) {
          return KeyboardVisibilityBuilder(
            builder: (context, isKeyboadVisible) {
              return Scaffold(
                body: Stack(
                  children: [
                    Center(
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
                                focusNode: emailFocusNode,
                                controller: emailController,
                                helperText: "E-Mail Adresse",
                                suffixIcon: Icons.mail,
                                type: TextInputType.emailAddress,
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              TextInputField(
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                helperText: "Passwort",
                                suffixIcon: Icons.vpn_key,
                                type: TextInputType.visiblePassword,
                              ),
                              StaySignedInCheckBox(
                                staySignedIn: staySignedIn,
                                setSignedIn: setSignedIn,
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40), // NEW
                                ),
                                onPressed: () => tryLogin(auth, context),
                                child: const Text("Anmelden"),
                              ),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40), // NEW
                                ),
                                onPressed: () => {},
                                //     handleTryAgainWithSavedCredentials(
                                //   auth,
                                //   context,
                                // ),
                                child: const Text("Erneut versuchen"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!isKeyboadVisible)
                      Positioned(
                        bottom: -80,
                        left: -35,
                        child: RegisterBlob(
                          onTap: () => navigateToRegisterPage(context),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
