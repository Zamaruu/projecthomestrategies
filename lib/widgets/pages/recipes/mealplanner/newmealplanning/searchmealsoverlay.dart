import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/mealsearchbar.dart';
import 'package:provider/provider.dart';

class SearchMealsOverlay extends StatefulWidget {
  const SearchMealsOverlay({Key? key}) : super(key: key);

  @override
  State<SearchMealsOverlay> createState() => _SearchMealsOverlayState();
}

class _SearchMealsOverlayState extends State<SearchMealsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Selector<NewMealPlanningState, bool>(
      selector: (context, state) => state.isSearchModalOpen,
      builder: (context, isModalOpen, _) {
        return IgnorePointer(
          ignoring: !isModalOpen,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            opacity: isModalOpen ? 1.0 : 0.0,
            child: Scaffold(
              backgroundColor: Colors.grey.withOpacity(0.6),
              body: const SearchMealBar(),
            ),
          ),
        );
      },
    );
  }
}
