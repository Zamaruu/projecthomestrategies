import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/drawermenu/draweravatar.dart';
import 'package:projecthomestrategies/widgets/drawermenu/drawertile.dart';
import 'package:projecthomestrategies/widgets/drawermenu/personalinfo.dart';
import 'package:provider/provider.dart';

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
            Selector<AuthenticationState, UserModel>(
              selector: (context, model) => model.sessionUser!,
              builder: (context, user, _) {
                return Padding(
                  padding: EdgeInsets.only(top: _padding, left: _padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DrawerAvatar(
                        firstLetter: user.firstname![0],
                        lastLetter: user.surname![0],
                      ),
                      PersonalInfo(
                        firstName: user.firstname!,
                        lastName: user.surname!,
                        familyGroup: user.household != null
                            ? user.household!.householdName!
                            : "Kein Mitglied eines Haushalts",
                      ),
                      SizedBox(
                        height: _padding,
                      )
                    ],
                  ),
                );
              },
            ),
            DrawerTile(
                icon: FontAwesomeIcons.home,
                drawerTitle: "Startseite",
                onClick: () =>
                    Global.navigateWithOutSamePush(context, "/homepage")),
            DrawerTile(
                icon: FontAwesomeIcons.table,
                drawerTitle: "Haushaltsplan",
                onClick: () {}),
            DrawerTile(
                icon: FontAwesomeIcons.listOl,
                drawerTitle: "Einkaufsliste",
                onClick: () {}),
            DrawerTile(
                icon: FontAwesomeIcons.utensils,
                drawerTitle: "Rezepte",
                onClick: () {}),
            DrawerTile(
                icon: FontAwesomeIcons.wallet,
                drawerTitle: "Rechnungen & Ausgaben",
                onClick: () =>
                    Global.navigateWithOutSamePush(context, "/bills")),
            DrawerTile(
                icon: FontAwesomeIcons.check,
                drawerTitle: "Aufgabenlisten",
                onClick: () {}),
            DrawerTile(
                icon: FontAwesomeIcons.users,
                drawerTitle: "Mein Haushalt",
                onClick: () =>
                    Global.navigateWithOutSamePush(context, "/household")),
            const Spacer(),
            DrawerTile(
                icon: FontAwesomeIcons.userCog,
                drawerTitle: "Mein Konto",
                onClick: () {}),
            DrawerTile(
                icon: FontAwesomeIcons.signOutAlt,
                drawerTitle: "Abmelden",
                onClick: () async {
                  await context.read<AuthenticationState>().signOut();
                }),
          ],
        ),
      ),
    );
  }
}
