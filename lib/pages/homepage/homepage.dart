import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/homepage/shoppinglist/shoppinglistpanel.dart';
import 'package:projecthomestrategies/widgets/homepage/tasks/pendingtaskspanel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> refreshHomePage(BuildContext ctx) async {
    var token = Global.getToken(ctx);
    var response = await NotificationService(token).getUnseenNotifcations();

    if (response.statusCode == 200) {
      ctx
          .read<AppCacheState>()
          .setOpenNotifications(response.object as List<NotificationModel>);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showNotification: true,
      pageTitle: "Startseite",
      body: RefreshIndicator(
        onRefresh: () => refreshHomePage(context),
        child: ListView(
          children: const [
            PendingTasksPanel(),
            ShoppinglistPanel(),
          ],
        ),
      ),
    );
  }
}
