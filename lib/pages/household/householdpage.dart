import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/authentication_state.dart';
import 'package:projecthomestrategies/bloc/household_model.dart';
import 'package:projecthomestrategies/pages/household/createhousehold.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:provider/provider.dart';




class HouseholdPage extends StatelessWidget {
  late HouseholdModel? household;

  HouseholdPage({Key? key}) : super(key: key);

  Widget checkIfUserHasHousehold(BuildContext context){
    household = context.read<AuthenticationState>().sessionUser!.household;

    if(household == null){
      return const CreateHouseholdPage();
    }
    else{
      return HouseholdManagement(householdModel: household!,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkIfUserHasHousehold(context);
  }
}

class HouseholdManagement extends StatelessWidget {
  final HouseholdModel householdModel;

  const HouseholdManagement({ Key? key, required this.householdModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: householdModel.householdName!, 
      body: Container(),
    );
  }
}