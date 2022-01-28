import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  IconData getIconFromtype() {
    switch (notification.type) {
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
    if (notification.seen!) {
      return Colors.grey[700]!;
    }
    switch (notification.type) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          getIconFromtype(),
          color: getColorFromType(),
        ),
        title: Text(
          notification.content!,
          style: TextStyle(
            fontWeight: notification.seen! ? null : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Am ${Global.datetimeToDeString(notification.created!)} von ${notification.creatorName!}",
        ),
        trailing: notification.seen!
            ? null
            : IconButton(
                tooltip: "Gesehen",
                splashColor: Colors.green,
                splashRadius: Global.splashRadius,
                visualDensity: VisualDensity.compact,
                onPressed: () {},
                icon: const Icon(Icons.done),
              ),
      ),
    );
  }
}
