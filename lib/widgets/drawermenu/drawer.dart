import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/main.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/draweravatar.dart';
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
        child: Consumer<AuthenticationState>(
          builder: (context, authState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _padding, left: _padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAvatar(
                        firstLetter: authState.sessionUser.firstname != null
                            ? authState.sessionUser.firstname![0]
                            : "",
                        lastLetter: authState.sessionUser.surname != null
                            ? authState.sessionUser.surname![0]
                            : "",
                        color: authState.sessionUser.color != null
                            ? authState.sessionUser.color!
                            : Colors.blue,
                      ),
                      PersonalInfo(
                        firstName: authState.sessionUser.firstname != null
                            ? authState.sessionUser.firstname!
                            : "",
                        lastName: authState.sessionUser.surname != null
                            ? authState.sessionUser.surname!
                            : "",
                        familyGroup: !authState.isUserPartOfHousehold()
                            ? authState.sessionUser.household!.householdName!
                            : "Kein Mitglied eines Haushalts",
                      ),
                      SizedBox(
                        height: _padding,
                      )
                    ],
                  ),
                ),
                DrawerTile(
                  routeName: "/homepage",
                  icon: FontAwesomeIcons.home,
                  drawerTitle: "Startseite",
                  isDisabled: authState.isUserPartOfHousehold(),
                  onClick: () =>
                      Global.navigateWithOutSamePush(context, "/homepage"),
                ),
                DrawerTile(
                  routeName: "",
                  icon: FontAwesomeIcons.table,
                  drawerTitle: "Haushaltsplan",
                  isDisabled: authState.isUserPartOfHousehold(),
                  onClick: () {},
                ),
                DrawerTile(
                  routeName: "",
                  icon: FontAwesomeIcons.listOl,
                  drawerTitle: "Einkaufsliste",
                  isDisabled: authState.isUserPartOfHousehold(),
                  onClick: () {},
                ),
                DrawerTile(
                  routeName: "/recipes",
                  icon: FontAwesomeIcons.utensils,
                  drawerTitle: "Rezepte [Beta]",
                  isDisabled: authState.isUserPartOfHousehold(),
                  onClick: () =>
                      Global.navigateWithOutSamePush(context, "/recipes"),
                ),
                DrawerTile(
                  routeName: "/bills",
                  icon: FontAwesomeIcons.wallet,
                  drawerTitle: "Rechnungen & Ausgaben [Beta]",
                  isDisabled: authState.isUserPartOfHousehold(),
                  onClick: () =>
                      Global.navigateWithOutSamePush(context, "/bills"),
                ),
                DrawerTile(
                  routeName: "",
                  icon: FontAwesomeIcons.check,
                  drawerTitle: "Aufgabenlisten",
                  isDisabled: authState.isUserPartOfHousehold(),
                  onClick: () {},
                ),
                DrawerTile(
                  routeName: "/household",
                  icon: FontAwesomeIcons.users,
                  drawerTitle: "Mein Haushalt [Beta]",
                  onClick: () => Global.navigateWithOutSamePush(
                    context,
                    "/household",
                  ),
                ),
                const Spacer(),
                DrawerTile(
                  routeName: "/settings",
                  icon: FontAwesomeIcons.userCog,
                  drawerTitle: "Mein Konto",
                  onClick: () => Global.navigateWithOutSamePush(
                    context,
                    "/settings",
                  ),
                ),
                DrawerTile(
                  routeName: "",
                  icon: FontAwesomeIcons.signOutAlt,
                  drawerTitle: "Abmelden",
                  onClick: () async {
                    await context.read<AuthenticationState>().signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeStrategies(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
