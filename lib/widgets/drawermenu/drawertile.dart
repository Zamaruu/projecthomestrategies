import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String drawerTitle;
  final Function onClick;
  final bool isDisabled;
  final String routeName;

  const DrawerTile({
    Key? key,
    required this.icon,
    required this.drawerTitle,
    required this.onClick,
    this.isDisabled = false,
    required this.routeName,
  }) : super(key: key);

  bool isRouteActive(BuildContext context) {
    Route route = ModalRoute.of(context) as Route;
    final currentRoute = route.settings.name;

    if (currentRoute != null) {
      if (currentRoute == routeName) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: isRouteActive(context)
          ? Theme.of(context).primaryColor.withOpacity(0.3)
          : null,
      hoverColor: Colors.blue,
      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: FaIcon(
          icon,
          size: 22,
          color: isDisabled
              ? Colors.grey[400]
              : isRouteActive(context)
                  ? Colors.black
                  : null,
        ),
      ),
      //tileColor: isDisabled ? Colors.grey[300] : null,
      title: Text(
        drawerTitle,
        style: TextStyle(
          fontWeight: isRouteActive(context) ? FontWeight.bold : null,
          color: isDisabled ? Colors.grey[400] : null,
        ),
      ),
      onTap: isDisabled ? null : () => onClick(),
    );
  }
}
