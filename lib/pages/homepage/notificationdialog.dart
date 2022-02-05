import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/notifcationmodel.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/pages/notifications/notificationlist.dart';
import 'package:projecthomestrategies/widgets/pages/notifications/notificationoptions.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  Future<void> refreshNotifications(BuildContext ctx) async {
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
    return Consumer<AppCacheState>(
      builder: (context, state, _) {
        return BaseScaffold(
          showActions: false,
          showMenuDrawer: false,
          trailing: const NotificationOptions(),
          pageTitle: state.openNotificaions.isEmpty
              ? "Benachrichtigungen"
              : "${state.countOpenNotifications()} Benachrichtigungen",
          body: state.countNotifications() <= 0
              ? const Center(
                  child: Text("Du hast keine Benachrichtigungen"),
                )
              : RefreshIndicator(
                  onRefresh: () => refreshNotifications(context),
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Column(
                        children: [
                          if (state.openNotificaions.isNotEmpty)
                            NotificationListBuilder(
                              notifications: state.sortNotifications(
                                state.openNotificaions,
                              ),
                              heading:
                                  "Neue Benachrichtigungen (${state.openNotificaions.length})",
                            ),
                          if (state.seenNotificaions.isNotEmpty)
                            NotificationListBuilder(
                              notifications: state.sortNotifications(
                                state.seenNotificaions,
                              ),
                              heading:
                                  "Ältere Benachrichtigungen (${state.seenNotificaions.length})",
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
