import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/notifcationmodel.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Global.getToken(context),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          return TokenProvider(
            tokenBuilder: (token) {
              debugPrint("Firebase JWT: $token");
              return FutureBuilder<ApiResponseModel>(
                future:
                    NotificationService(snapshot.data!).getAllNotifcations(),
                builder: (BuildContext context,
                    AsyncSnapshot<ApiResponseModel> snapshot) {
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
                    var notifications = snapshot.data!.object;

                    var open = notifications == null
                        ? <NotificationModel>[]
                        : snapshot.data!.object["OpenNotifications"];
                    var seen = notifications == null
                        ? <NotificationModel>[]
                        : snapshot.data!.object["SeenNotifications"];
                    context
                        .read<AppCacheState>()
                        .setInitialNotificationData(open, seen);
                    return const HomePage();
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
