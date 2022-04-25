import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/newmealplanningdialog.dart';
import 'package:provider/provider.dart';

class NewMealPlanningBuilder extends StatelessWidget {
  const NewMealPlanningBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewMealPlanningState(),
      child: const NewMealPlanningDialog(),
    );
  }
}
