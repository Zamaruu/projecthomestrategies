import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/household_model.dart';
import 'package:projecthomestrategies/pages/household/household_management_page.dart';
import 'package:projecthomestrategies/service/household_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/homestrategies_fullscreen_loader.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingprocessor.dart';

class HouseholdManagementBuilder extends StatelessWidget {
  final HouseholdModel householdModel;

  const HouseholdManagementBuilder({Key? key, required this.householdModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TokenProvider(
      tokenBuilder: (token) {
        return FutureBuilder<ApiResponseModel>(
          future: HouseholdService(token)
              .getHouseholdForManagement(householdModel.householdId!),
          builder:
              (BuildContext context, AsyncSnapshot<ApiResponseModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const HomestrategiesFullscreenLoader(
                loaderLabel: "Lade Haushalt",
              );
            }
            if (snapshot.hasError || snapshot.data!.hasError!) {
              var error = snapshot.hasError
                  ? snapshot.error.toString
                  : snapshot.data!.message;
              return ErrorPageHandler(error: error as String);
            } else {
              return HouseholdManagement(
                householdModel: snapshot.data!.object as HouseholdModel,
              );
            }
          },
        );
      },
    );
  }
}
