import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/service/household_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/confirmationdialog.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/usertile.dart';
import 'package:provider/provider.dart';

class UserManagementTile extends StatefulWidget {
  final UserModel user;
  final Function onRemove;
  final int householdId;

  const UserManagementTile(
      {Key? key,
      required this.user,
      required this.onRemove,
      required this.householdId})
      : super(key: key);

  @override
  _UserManagementTileState createState() => _UserManagementTileState();
}

class _UserManagementTileState extends State<UserManagementTile> {
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Future<bool> confirmRemovalOfPerson(BuildContext ctx) async {
    var result = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return ConfirmationDialog(
          title: "Mitglied entfernen?",
          content:
              "Willst du ${widget.user.firstname} ${widget.user.surname} wirklich aus dem Haushalt entfernen?",
          confirmText: "Entfernen",
        );
      },
    );
    if (result != null) {
      return result;
    }
    return false;
  }

  Future<void> handleRemovePerson(BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });
    var token = ctx.read<AuthenticationState>().token;
    var response = await HouseholdService(token).removeUserFromHousehold(
      widget.user,
      widget.householdId,
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      widget.onRemove();
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint(response.toString());
    }
  }

  IconButton removePersonButton(BuildContext ctx) {
    return IconButton(
      splashRadius: Global.splashRadius,
      visualDensity: VisualDensity.compact,
      tooltip: "Benutzer entfernen",
      onPressed: () async {
        var confirmation = await confirmRemovalOfPerson(ctx);
        if (confirmation) {
          handleRemovePerson(ctx);
        }
      },
      icon: const Icon(Icons.person_remove),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserTile(
      user: widget.user,
      trailing: isLoading
          ? SizedBox(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : removePersonButton(context),
    );
  }
}
