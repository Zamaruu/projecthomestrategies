import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:provider/provider.dart';

class SearchMealsOverlay extends StatelessWidget {
  const SearchMealsOverlay({Key? key}) : super(key: key);

  Widget buildFloatingSearchBar(BuildContext ctx) {
    final isPortrait = MediaQuery.of(ctx).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Rezepte durchsuchen...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      automaticallyImplyBackButton: false,
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      onSubmitted: (query) {},
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: () {
              ctx.read<NewMealPlanningState>().setIsSearchModalOpen(false);
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

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
              body: Container(
                child: buildFloatingSearchBar(context),
              ),
            ),
          ),
        );
      },
    );
  }
}
