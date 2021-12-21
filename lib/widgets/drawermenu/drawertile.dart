import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String drawerTitle;
  final Function onClick;

  const DrawerTile({ Key? key, required this.icon, required this.drawerTitle, required this.onClick }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      hoverColor: Colors.blue,
      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: FaIcon(icon, size: 22,),
      ),
      title: Text(drawerTitle),
      onTap: () => onClick,
    );
  }
}