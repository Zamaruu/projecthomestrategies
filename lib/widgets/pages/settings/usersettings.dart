import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/basiccard.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:projecthomestrategies/widgets/pages/settings/datatile.dart';
import 'package:provider/provider.dart';

import 'colorselectiontile.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<FirebaseAuthenticationState, UserModel>(
      selector: (context, model) => model.sessionUser,
      builder: (context, user, _) {
        return BasicCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PanelHeading(
                heading: "Benutzereinstellungen",
                textColor: Theme.of(context).primaryColor,
                padding: 12.0,
              ),
              DataTile(
                data: user.firstname!,
                onTap: () {},
              ),
              DataTile(
                data: user.surname!,
                onTap: () {},
              ),
              DataTile(
                data: user.email!,
                onTap: () {},
              ),
              const SelectColorTile()
            ],
          ),
        );
      },
    );
  }
}
