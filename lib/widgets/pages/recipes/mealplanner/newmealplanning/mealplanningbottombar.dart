import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:provider/provider.dart';

class MealPlanningBottomBar extends StatelessWidget {
  final Function onCreate;

  const MealPlanningBottomBar({Key? key, required this.onCreate})
      : super(key: key);

  void _abortEditing(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey.shade400),
        ),
      ),
      height: kBottomNavigationBarHeight,
      child: Selector<NewMealPlanningState, bool>(
        selector: (context, model) => model.isLoading,
        builder: (context, isLoading, _) => Row(
          children: [
            SizedBox(
              height: kBottomNavigationBarHeight,
              width: MediaQuery.of(context).size.width / 2,
              child: TextButton.icon(
                onPressed: isLoading ? null : () => _abortEditing(context),
                style: TextButton.styleFrom(
                  primary: Colors.grey.shade700,
                ),
                icon: const Icon(Icons.clear),
                label: const Text("Abbrechen"),
              ),
            ),
            SizedBox(
              height: kBottomNavigationBarHeight,
              width: MediaQuery.of(context).size.width / 2,
              child: TextButton.icon(
                onPressed: isLoading ? null : () => onCreate(),
                style: TextButton.styleFrom(),
                icon: const Icon(Icons.done),
                label: const Text("Erstellen"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
