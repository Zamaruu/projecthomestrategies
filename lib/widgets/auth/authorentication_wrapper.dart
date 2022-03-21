import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/utils/securestoragehandler.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  final Widget child;

  const AuthenticationWrapper({Key? key, required this.child})
      : super(key: key);

  Future<bool> tryAuthentication(BuildContext ctx) async {
    var credentials = await SecureStorageHandler().getLoggedInUserCredentials();

    if (credentials != null) {
      await ctx
          .read<AuthenticationState>()
          .signInWithSavedCredentials(credentials, ctx);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthenticationState, Status>(
      selector: (context, model) => model.status,
      builder: (context, authStatus, _) {
        if (authStatus == Status.authenticated) {
          return child;
        } else {
          return FutureBuilder<bool>(
            future: tryAuthentication(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return ErrorPageHandler(error: snapshot.error.toString());
              } else {
                if (!snapshot.data!) {
                  return const ErrorPageHandler(
                    error: "Wir konnten dich leider nicht anmelden!",
                  );
                }
                return child;
              }
            },
          );
        }
      },
    );
  }
}
