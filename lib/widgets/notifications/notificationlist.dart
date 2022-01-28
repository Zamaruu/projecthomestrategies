import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projecthomestrategies/bloc/notifcationmodel.dart';
import 'package:projecthomestrategies/widgets/homepage/panelheading.dart';
import 'package:projecthomestrategies/widgets/notifications/notificationcard.dart';

class NotificationListBuilder extends StatelessWidget {
  final String heading;
  final List<NotificationModel> notifications;

  const NotificationListBuilder({
    Key? key,
    required this.notifications,
    required this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PanelHeading(heading: heading),
        AnimationLimiter(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: NotificationCard(notification: notifications[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
