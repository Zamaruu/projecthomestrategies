import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/pages/recipes/mealplannerpage.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class MealPlannerPageBuilder extends StatelessWidget {
  const MealPlannerPageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (context, auth, _) => FutureBuilder<ApiResponseModel>(
        future: RecipeService(auth.token).getPlannedMeals(),
        builder: (
          BuildContext context,
          AsyncSnapshot<ApiResponseModel> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.transparent,
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
            var plannedMeals = snapshot.data!.object as List<PlannedMealModel>;
            context
                .read<RecipeState>()
                .setInitialMealPlanningData(plannedMeals);

            return const MealPlannerPage();
          }
        },
      ),
    );
  }
}
