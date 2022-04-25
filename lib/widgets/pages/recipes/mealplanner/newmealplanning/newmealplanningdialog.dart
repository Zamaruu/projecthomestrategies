import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/searchmealsoverlay.dart';
import 'package:provider/provider.dart';

class NewMealPlanningDialog extends StatelessWidget {
  const NewMealPlanningDialog({Key? key}) : super(key: key);

  Future<bool> _shouldPop(BuildContext ctx) async {
    var isSearchModalOpen = ctx.read<NewMealPlanningState>().isSearchModalOpen;
    if (isSearchModalOpen) {
      ctx.read<NewMealPlanningState>().setIsSearchModalOpen(false);
      return false;
    }
    return true;
  }

  OutlinedButton _addButton(BuildContext ctx) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(90),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: BorderSide(
          color: Theme.of(ctx).primaryColor.withOpacity(0.5),
        ),
      ),
      onPressed: () => {
        ctx.read<NewMealPlanningState>().setIsSearchModalOpen(true),
      },
      icon: const Icon(Icons.ramen_dining),
      label: const Text("Rezept auswählen"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _shouldPop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("Neues Planning")),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _addButton(context),
              ],
            ),
            const SearchMealsOverlay(),
          ],
        ),
      ),
    );
  }
}
