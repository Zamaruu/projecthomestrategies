import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class NotificationOptions extends StatelessWidget {
  const NotificationOptions({Key? key}) : super(key: key);

  //Methods
  Future<void> setAllNotificationsOnSeen(
    BuildContext ctx,
    List<int> ids,
  ) async {
    var token = Global.getToken(ctx);

    _loader(ctx);
    var response = await NotificationService(token).setNotificationsOnseen(ids);
    _dismissSnackbar(ctx);

    if (response.statusCode == 200) {
      ctx.read<AppCacheState>().setAllOpenNotificationsToSeen();
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  Future<void> deleteAllNotifications(BuildContext ctx) async {
    var token = Global.getToken(ctx);

    _loader(ctx);
    var response = await NotificationService(token).deleteAllNotifications();
    _dismissSnackbar(ctx);

    if (response.statusCode == 200) {
      ctx.read<AppCacheState>().deleteAllNotifications();
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  void _loader(BuildContext ctx) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(ctx).primaryColor,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Bitte warte einen Augenblick :)",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }

  void _dismissSnackbar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  }

  //Widgets
  Row menuItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppCacheState>(
      builder: (context, model, _) {
        return PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          onSelected: (value) {
            if (value == 1) {
              setAllNotificationsOnSeen(
                context,
                model.openNotificaions.map((e) => e.notificationId!).toList(),
              );
            } else {
              deleteAllNotifications(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: model.openNotificaions.isNotEmpty,
              child: menuItem("Alle gesehen", Icons.visibility),
              value: 1,
            ),
            PopupMenuItem(
              enabled: model.countNotifications() >= 1,
              child: menuItem("Alle löschen", Icons.delete),
              value: 2,
            )
          ],
        );
      },
    );
  }
}
