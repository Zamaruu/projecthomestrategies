import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/signinpage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:provider/provider.dart';

class AuthenticationHander extends StatelessWidget {
  const AuthenticationHander({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (BuildContext context, AuthenticationState authState, _){
        switch(authState.status){
          case Status.uninitialized:
            return const SignInPage();
          case Status.unauthenticated:
            return const SignInPage();
          case Status.authenticating:
            return const HomePage();
          case Status.authenticated:
            return const HomePage();
          default:
            return const Scaffold();
        }
      }
    );
  }
}