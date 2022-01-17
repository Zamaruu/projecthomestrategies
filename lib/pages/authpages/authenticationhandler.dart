import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/pages/authpages/signinpage.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/utils/securestoragehandler.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';
import 'package:provider/provider.dart';

class AuthenticationHander extends StatelessWidget {
  const AuthenticationHander({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecureStorageHandler().getLoggedInUserCredentials(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const LoadingProcess();
        }
        else if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        else{
          return Consumer<AuthenticationState>(
            builder: (BuildContext context, AuthenticationState authState, _){
              if(snapshot.data != null && authState.status == Status.uninitialized){
                authState.signInWithSavedCredentials(snapshot.data!);
              }
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
      },
    );
    
  }
}