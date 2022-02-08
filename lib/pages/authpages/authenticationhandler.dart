import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/signinpage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/pages/homepage/initialloader.dart';
import 'package:projecthomestrategies/utils/securestoragehandler.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingprocessor.dart';
import 'package:provider/provider.dart';

class AuthenticationHander extends StatelessWidget {
  const AuthenticationHander({Key? key}) : super(key: key);

  Future<void> tryLoginWithSafedCredentials(BuildContext ctx) async {
    var credentials = await SecureStorageHandler().getLoggedInUserCredentials();

    if (credentials != null) {
      await ctx
          .read<AuthenticationState>()
          .signInWithSavedCredentials(credentials, ctx);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tryLoginWithSafedCredentials(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProcess();
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Selector<AuthenticationState, Status>(
            selector: (context, model) => model.status,
            builder: (BuildContext context, Status status, _) {
              switch (status) {
                case Status.uninitialized:
                  return const SignInPage();
                case Status.unauthenticated:
                  return const SignInPage();
                // case Status.authenticated:
                //   return const InitialLoader();
                default:
                  return const LoadingProcess();
                // return const ErrorPageHandler(
                //   error: "Es gab einen Fehler bei der Autehtifizierung!",
                // );
              }
            },
          );
        }
      },
    );
  }
}
