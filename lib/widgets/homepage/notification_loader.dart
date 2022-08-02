import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/notifcationmodel.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/pages/homepage/homepage.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class NotificationLoader extends StatelessWidget {
  final String token;

  const NotificationLoader({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponseModel>(
      future: NotificationService(token).getAllNotifcations(),
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
          var notifications = snapshot.data!.object;

          var open = notifications == null
              ? <NotificationModel>[]
              : snapshot.data!.object["OpenNotifications"];
          var seen = notifications == null
              ? <NotificationModel>[]
              : snapshot.data!.object["SeenNotifications"];
          context.read<AppCacheState>().setInitialNotificationData(open, seen);
          return const HomePage();
        }
      },
    );
  }
}
