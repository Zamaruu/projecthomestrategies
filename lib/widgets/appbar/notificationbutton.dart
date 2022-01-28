import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/pages/homepage/notificationdialog.dart';
import 'package:provider/provider.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({Key? key}) : super(key: key);

  void openNotifications(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (ctx) => const NotificationDialog(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppCacheState>(
      builder: (ctx, model, _) {
        return Badge(
          showBadge: model.openNotificaions.isNotEmpty,
          position: const BadgePosition(
            top: 5,
            end: 5,
          ),
          badgeContent: Text(
            "${model.openNotificaions.length}",
            style: const TextStyle(color: Colors.white),
          ),
          child: IconButton(
            splashRadius: Global.splashRadius,
            onPressed: () => openNotifications(context),
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
