import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: const BadgePosition(
        top: 5,
        end: 5,
      ),
      badgeContent: const Text(
        "2",
        style: TextStyle(
          color: Colors.white
        ),
      ),
      child: IconButton(
        splashRadius: Global.splashRadius,
        onPressed: (){}, 
        icon: const Icon(
          Icons.notifications_none, 
          color: Colors.white,
        ),
      ),
    );
  }
}