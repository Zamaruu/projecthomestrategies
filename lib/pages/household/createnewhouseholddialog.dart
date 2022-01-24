import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/pages/household/addpersontohousehold.dart';
import 'package:projecthomestrategies/service/household_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/somesrategiesloadingbuilder.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/usertile.dart';
import 'package:provider/provider.dart';

class CreateHouseholdDialog extends StatefulWidget {
  final UserModel sessionUser;

  const CreateHouseholdDialog({Key? key, required this.sessionUser})
      : super(key: key);

  @override
  _CreateHouseholdDialogState createState() => _CreateHouseholdDialogState();
}

class _CreateHouseholdDialogState extends State<CreateHouseholdDialog> {
  late bool isLoading;
  late TextEditingController householdNameController;
  late List<UserModel> householdMember;

  @override
  void initState() {
    isLoading = false;
    householdNameController = TextEditingController();
    householdMember = <UserModel>[];
    householdMember.add(widget.sessionUser);
    super.initState();
  }

  //Methoden
  void toggleLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  //Add persons to household
  void removePersonFromHousehold(int index) {
    if (index == 0) {
      return;
    } else {
      setState(() {
        householdMember.removeAt(index);
      });
    }
  }

  void addPersonToHousehold(UserModel newUser) {
    var exists =
        householdMember.where((element) => element.email == newUser.email);
    if (exists.isEmpty) {
      setState(() {
        householdMember.add(newUser);
      });
    }
  }

  Future<void> addPersonToHouseholdDialog(BuildContext ctx) async {
    var response = await showDialog<ApiResponseModel>(
      context: ctx,
      builder: (context) {
        return const AddUserToHousehold();
      },
    );

    if (response != null) {
      if (response.statusCode == 200) {
        addPersonToHousehold(response.object as UserModel);
      }
    } else {
      // TODO implement response handling
      debugPrint(response.toString());
    }
  }

  //Household creation methods
  bool validInformationForCreation() {
    if (householdNameController.text.trim().isEmpty) {
      return false;
    }
    if (householdMember.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> createNewHousehold(BuildContext ctx) async {
    if (!validInformationForCreation()) {
      // TODO handle if infos are not valid
      return;
    } else {
      HouseholdModel newHousehold = HouseholdModel(
        householdName: householdNameController.text.trim(),
        householdMember: householdMember,
        adminId: widget.sessionUser.userId,
      );

      toggleLoading(true);
      var token = ctx.read<AuthenticationState>().token;
      var response =
          await HouseholdService(token).createNewHousehold(newHousehold);

      if (response.statusCode == 200) {
        var uResponse = await addUsersToHousehold(
          token,
          response.object as HouseholdModel,
        );

        ctx
            .read<AuthenticationState>()
            .addHouseholdToSessionUser(response.object as HouseholdModel);
      }

      debugPrint(response.toString());
      toggleLoading(false);
    }
  }

  Future<List<int>> addUsersToHousehold(
    String token,
    HouseholdModel householdModel,
  ) async {
    List<int> responses = <int>[];

    for (var user in householdMember) {
      var response = await HouseholdService(token).addUserToHousehold(
        user,
        householdModel.householdId!,
      );
      responses.add(response.statusCode);
    }

    return responses;
  }

  //Widgets
  IconButton removePerson(int index) {
    return IconButton(
      splashRadius: Global.splashRadius,
      visualDensity: VisualDensity.compact,
      tooltip: "Benutzer entfernen",
      onPressed: () => removePersonFromHousehold(index),
      icon: const Icon(Icons.person_remove),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeStrategiesLoadingBuilder(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text("Neuer Haushalt")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextInputField(
                controller: householdNameController,
                helperText: "Name des Haushalts",
                type: TextInputType.text,
                maxChars: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Haushaltsmitglieder: ${householdMember.length.toString()}",
                  ),
                  PrimaryButton(
                    onPressed: () => addPersonToHouseholdDialog(context),
                    text: "Hinzufügen",
                    icon: Icons.person_add,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: householdMember.length,
              itemBuilder: (BuildContext context, int index) {
                if (index > 0) {
                  return UserTile(
                    user: householdMember[index],
                    trailing: removePerson(index),
                  );
                } else {
                  return UserTile(
                    user: householdMember[index],
                  );
                }
              },
            ),
            const Spacer(),
            CreateNewHouseholdButton(
              onPressed: () => createNewHousehold(context),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateNewHouseholdButton extends StatelessWidget {
  final Function onPressed;
  const CreateNewHouseholdButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: () => onPressed(),
            child: const Center(
              child: Text(
                "Haushalt erstellen",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
