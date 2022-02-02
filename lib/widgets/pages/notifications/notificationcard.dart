import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/notifcationmodel.dart';
import 'package:projecthomestrategies/bloc/provider/appcache_state.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/notification_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void toggleLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  IconData getIconFromtype() {
    switch (widget.notification.type) {
      case NotificationType.created:
        return Icons.add_circle;
      case NotificationType.deleted:
        return Icons.delete_forever;
      case NotificationType.edited:
        return Icons.edit;
      case NotificationType.info:
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color getColorFromType() {
    if (widget.notification.seen!) {
      return Colors.grey[700]!;
    }
    switch (widget.notification.type) {
      case NotificationType.created:
        return Colors.green;
      case NotificationType.deleted:
        return Colors.red;
      case NotificationType.edited:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget trailing(BuildContext ctx) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: Theme.of(ctx).primaryColor,
        ),
      );
    }
    return IconButton(
      tooltip: "Gesehen",
      splashColor: Colors.green,
      splashRadius: Global.splashRadius,
      visualDensity: VisualDensity.compact,
      onPressed: () => setNotificationOnSeen(ctx),
      icon: const Icon(Icons.done),
    );
  }

  Future<void> setNotificationOnSeen(BuildContext ctx) async {
    toggleLoading(true);
    var token = ctx.read<AuthenticationState>().token;
    var response = await NotificationService(token).setNotificationOnseen(
      widget.notification.notificationId!,
    );

    toggleLoading(false);
    if (response.statusCode == 200) {
      ctx.read<AppCacheState>().setNotificationToSeen(widget.notification);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: context,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          getIconFromtype(),
          color: getColorFromType(),
        ),
        title: Text(
          widget.notification.content!,
          style: TextStyle(
            fontWeight: widget.notification.seen! ? null : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Am ${Global.datetimeToDeString(widget.notification.created!)} von ${widget.notification.creatorName!}",
        ),
        trailing: widget.notification.seen! ? null : trailing(context),
      ),
    );
  }
}
