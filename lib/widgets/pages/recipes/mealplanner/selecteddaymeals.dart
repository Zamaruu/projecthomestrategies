import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';

class SelectedDayMeals extends StatelessWidget {
  final List<PlannedMealModel>? meals;

  const SelectedDayMeals({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Global.isListNullOrEmpty(meals)) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: meals!.length,
        itemBuilder: (BuildContext context, int index) {
          return RecipeCard(recipe: meals![index].recipe!);
        },
      );
    } else {
      return const Center(
        child: Text("Noch kein Essen geplant!"),
      );
    }
  }
}
