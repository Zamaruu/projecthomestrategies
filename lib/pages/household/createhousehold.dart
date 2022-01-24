import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/pages/household/createnewhouseholddialog.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:provider/provider.dart';

class CreateHouseholdPage extends StatelessWidget {
  const CreateHouseholdPage({Key? key}) : super(key: key);

  void createNewHousehold(BuildContext ctx, UserModel sessionUser) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateHouseholdDialog(
          sessionUser: sessionUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Haushalt erstellen",
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => createNewHousehold(
                context,
                context.read<AuthenticationState>().sessionUser,
              ),
              child: const Icon(
                Icons.group_add,
                color: Colors.white,
                size: 43,
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                primary: Theme.of(context).primaryColor, // <-- Button color
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Erstellen Sie einen neuen Haushalt",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
