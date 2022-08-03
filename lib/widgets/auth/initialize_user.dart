import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/service/user_service.dart';
import 'package:projecthomestrategies/utils/homestrategies_fullscreen_loader.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class InitializeUser extends StatelessWidget {
  final Widget child;
  final String token;

  const InitializeUser({Key? key, required this.child, required this.token})
      : super(key: key);

  void setSessionData(BuildContext ctx, ApiResponseModel data) {
    var user = data.object as UserModel;

    ctx.read<FirebaseAuthenticationState>().setUser(user);
    if (user.household != null) {
      ctx.read<FirebaseAuthenticationState>().setHosuehold(user.household!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponseModel>(
      future: UserService(token).getMe(),
      builder:
          (BuildContext context, AsyncSnapshot<ApiResponseModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const HomestrategiesFullscreenLoader(
            loaderLabel: "Lade Benutzerdaten",
          );
        } else if (snapshot.hasError) {
          return ErrorPageHandler(error: snapshot.error.toString());
        } else {
          setSessionData(context, snapshot.data!);
          return child;
        }
      },
    );
  }
}
