import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponseModel>(
      future: NotificationService(context.read<AuthenticationState>().token)
          .getAllNotifcations(),
      builder:
          (BuildContext context, AsyncSnapshot<ApiResponseModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorPageHandler(error: snapshot.error.toString());
        } else {
          return ChangeNotifierProvider(
            create: (context) => AppCacheState(
              snapshot.data!.object["OpenNotifications"],
              snapshot.data!.object["SeenNotifications"],
              [],
              [],
            ),
            child: const HomePage(),
          );
        }
      },
    );
  }
}
