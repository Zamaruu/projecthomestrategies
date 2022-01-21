import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/bloc/user_model.dart';
import 'package:projecthomestrategies/pages/household/addpersontohousehold.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/household_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/usertile.dart';
import 'package:projecthomestrategies/widgets/household/usermangementtile.dart';
import 'package:provider/provider.dart';

class HouseholdDataLoader extends StatelessWidget {
  final HouseholdModel householdModel;

  const HouseholdDataLoader({Key? key, required this.householdModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponseModel>(
      future: HouseholdService(context.read<AuthenticationState>().token)
          .getHouseholdForManagement(householdModel.householdId!),
      builder:
          (BuildContext context, AsyncSnapshot<ApiResponseModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProcess();
        }
        if (snapshot.hasError || snapshot.data!.hasError!) {
          var error = snapshot.hasError
              ? snapshot.error.toString
              : snapshot.data!.message;
          return ErrorPageHandler(error: error as String);
        } else {
          // List<UserModel> member = List<UserModel>.from(
          //   snapshot.data!.object.map((model) => UserModel.fromJson(model)),
          // );
          // householdModel.householdMember = member;
          return HouseholdManagement(
            householdModel: snapshot.data!.object as HouseholdModel,
          );
        }
      },
    );
  }
}

class HouseholdManagement extends StatefulWidget {
  final HouseholdModel householdModel;

  const HouseholdManagement({Key? key, required this.householdModel})
      : super(key: key);

  @override
  State<HouseholdManagement> createState() => _HouseholdManagementState();
}

class _HouseholdManagementState extends State<HouseholdManagement> {
  late UserModel householdAdmin;

  @override
  void initState() {
    householdAdmin = widget.householdModel.householdCreator!;
    super.initState();
  }

  //Methoden
  void removePersonFromHousehold(int index) {
    if (index == 0) {
      return;
    } else {
      setState(() {
        widget.householdModel.householdMember!.removeAt(index);
      });
      // TODO delete user from household with api
    }
  }

  Future<void> addPersonToHousehold(UserModel newUser, BuildContext ctx) async {
    var exists = widget.householdModel.householdMember!
        .where((element) => element.email == newUser.email);
    if (exists.isEmpty) {
      var token = ctx.read<AuthenticationState>().token;

      var response = await HouseholdService(token).addUserToHousehold(
        newUser,
        widget.householdModel.householdId!,
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.householdModel.householdMember!.add(
            response.object as UserModel,
          );
        });
      } else {
        debugPrint(response.toString());
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
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
        addPersonToHousehold(response.object as UserModel, ctx);
      } else {
        debugPrint(response.toString());
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
    }
  }

  Widget buildMemberListElement(int index) {
    var buildUser = widget.householdModel.householdMember![index];
    if (buildUser.email == householdAdmin.email) {
      return UserTile(
        user: buildUser,
        trailing: const Text("Admin"),
      );
    } else {
      return UserManagementTile(
        user: buildUser,
        onRemove: () => removePersonFromHousehold(index),
        householdId: widget.householdModel.householdId!,
      );
    }
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
    return BaseScaffold(
      pageTitle: widget.householdModel.householdName!,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Haushaltsmitglieder: ${widget.householdModel.householdMember!.length.toString()}",
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
            itemCount: widget.householdModel.householdMember!.length,
            itemBuilder: (BuildContext context, int index) {
              return buildMemberListElement(index);
            },
          ),
        ],
      ),
    );
  }
}
