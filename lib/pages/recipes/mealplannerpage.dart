import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/mealplannercalendar.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanningbuilder.dart';
import 'package:provider/provider.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({Key? key}) : super(key: key);

  Future<void> _fetchMealPlannings(BuildContext ctx) async {
    var loader = LoadingSnackbar(ctx);
    var token = Global.getToken(ctx);

    loader.showLoadingSnackbar();
    ctx.read<RecipeState>().setIsLoading(true);
    var response = await RecipeService(token).getPlannedMeals();

    ctx.read<RecipeState>().setIsLoading(false);
    loader.dismissSnackbar();

    if (response.isSuccess()) {
      ctx.read<RecipeState>().setMealPlannings(response.object, notify: true);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  Future<void> _newMealPlanningDialog(BuildContext ctx) async {
    var result = await Navigator.of(ctx).push<bool?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const NewMealPlanningBuilder(),
      ),
    );

    if (result != null) {
      if (result) {
        _fetchMealPlannings(ctx);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Selector<RecipeState, List<PlannedMealModel>>(
        selector: (context, state) => state.plannedMeals,
        builder: (context, plannedMeals, _) {
          return MealPlannerCalendar(
            meals: plannedMeals,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "MealPlannerFAB",
        onPressed: () => _newMealPlanningDialog(context),
        tooltip: "Neues Rezept erstellen",
        child: const Icon(Icons.add),
      ),
    );
  }
}
