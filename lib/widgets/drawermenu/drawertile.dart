import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String drawerTitle;
  final Function onClick;
  final bool isDisabled;

  const DrawerTile({
    Key? key,
    required this.icon,
    required this.drawerTitle,
    required this.onClick,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      hoverColor: Colors.blue,
      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: FaIcon(
          icon,
          size: 22,
          color: isDisabled ? Colors.grey[400] : null,
        ),
      ),
      //tileColor: isDisabled ? Colors.grey[300] : null,
      title: Text(
        drawerTitle,
        style: TextStyle(
          color: isDisabled ? Colors.grey[400] : null,
        ),
      ),
      onTap: isDisabled ? null : () => onClick(),
    );
  }
}
