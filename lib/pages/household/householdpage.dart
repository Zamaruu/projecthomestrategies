import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/pages/household/createhousehold.dart';
import 'package:projecthomestrategies/pages/household/householdmanagementpage.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HouseholdPage extends StatelessWidget {
  late HouseholdModel? household;

  HouseholdPage({Key? key}) : super(key: key);

  Widget checkIfUserHasHousehold(BuildContext context) {
    household = context.read<AuthenticationState>().sessionUser.household;

    if (household == null) {
      return const CreateHouseholdPage();
    } else {
      return HouseholdDataLoader(
        householdModel: household!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkIfUserHasHousehold(context);
  }
}
