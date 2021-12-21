import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projecthomestrategies/widgets/drawermenu/draweravatar.dart';
import 'package:projecthomestrategies/widgets/drawermenu/drawertile.dart';
import 'package:projecthomestrategies/widgets/drawermenu/personalinfo.dart';

class MenuDrawer extends StatelessWidget {
  final double _padding = 20.0;
  
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: _padding, left: _padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DrawerAvatar(),
                  const PersonalInfo(firstName: "Maximilian", lastName: "Ditz", familyGroup: "Paderborner Kids"),
                  SizedBox(height: _padding,)
                ],
              ),
            ),
            DrawerTile(icon: FontAwesomeIcons.table, drawerTitle: "Haushaltsplan", onClick: (){}),
            DrawerTile(icon: FontAwesomeIcons.listOl, drawerTitle: "Einkaufsliste", onClick: (){}),
            DrawerTile(icon: FontAwesomeIcons.utensils, drawerTitle: "Rezepte", onClick: (){}),
            DrawerTile(icon: FontAwesomeIcons.wallet, drawerTitle: "Rechnungen & Ausgaben", onClick: (){}),
            DrawerTile(icon: FontAwesomeIcons.check, drawerTitle: "Aufgabenlisten", onClick: (){}),
            DrawerTile(icon: FontAwesomeIcons.users, drawerTitle: "Mein Haushalt", onClick: (){}),
            const Spacer(),
            DrawerTile(icon: FontAwesomeIcons.userCog, drawerTitle: "Mein Konto", onClick: (){}),
            DrawerTile(icon: FontAwesomeIcons.signOutAlt, drawerTitle: "Abmelden", onClick: (){}),
          ],
        ),
      ),
    );
  }
}