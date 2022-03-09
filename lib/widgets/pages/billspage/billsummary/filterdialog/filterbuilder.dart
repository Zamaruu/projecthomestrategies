import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/service/household_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';

import 'filterdialog.dart';

class FilterBuilder extends StatelessWidget {
  const FilterBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HouseholdService(Global.getToken(context)).getMemberOfHousehold(
        Global.getCurrentUser(context).household!.householdId!,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return ErrorPageHandler(error: snapshot.error.toString());
        } else {
          return const FilterDialog();
        }
      },
    );
  }
}
