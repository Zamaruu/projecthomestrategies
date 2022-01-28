import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/notifications/notificationcard.dart';
import 'package:projecthomestrategies/widgets/notifications/notificationlist.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppCacheState>(
      builder: (context, state, _) {
        return BaseScaffold(
          showActions: false,
          showMenuDrawer: false,
          pageTitle: state.openNotificaions.isEmpty
              ? "Benachrichtigungen"
              : "${state.countOpenNotifications()} Benachrichtigungen",
          body: state.countNotifications() <= 0
              ? const Center(
                  child: Text("Du hast keine Benachrichtigungen"),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      NotificationListBuilder(
                        notifications: state.openNotificaions,
                        heading: "Ungsehen: ${state.openNotificaions.length}",
                      ),
                      NotificationListBuilder(
                        notifications: state.seenNotificaions,
                        heading: "Gesehen: ${state.seenNotificaions.length}",
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
