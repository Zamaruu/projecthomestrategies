import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/searchmealhistory.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchMealsOverlay extends StatefulWidget {
  const SearchMealsOverlay({Key? key}) : super(key: key);

  @override
  State<SearchMealsOverlay> createState() => _SearchMealsOverlayState();
}

class _SearchMealsOverlayState extends State<SearchMealsOverlay> {
  late List<FullRecipeModel> queryiedRecipes;
  late bool isLoading;
  late FloatingSearchBarController barController;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    queryiedRecipes = <FullRecipeModel>[];
    barController = FloatingSearchBarController();
  }

  void _toggleIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> _addItemToSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    var history = prefs.getStringList(Global.kMealSearchHistoryKey);
    List<String> newHistory = <String>[];

    if (!Global.isListNullOrEmpty(history)) {
      // Check if Item is already in Serach History
      for (var item in history!) {
        if (item.toLowerCase() == query.toLowerCase()) {
          return;
        }
      }

      newHistory = history;
    }
    if (query.isNotEmpty) {
      newHistory.add(query);
    }
    await prefs.setStringList(Global.kMealSearchHistoryKey, newHistory);
  }

  Future<dynamic> _getRecipesByName(BuildContext ctx, String query) async {
    if (query.isEmpty) {
      return;
    }

    _toggleIsLoading(true);

    await _addItemToSearchHistory(query);
    var token = ctx.read<AuthenticationState>().token;
    var response = await RecipeService(token).queryRecipesByName(query);

    _toggleIsLoading(false);

    if (response.isSuccess()) {
      setState(() {
        queryiedRecipes = response.object as List<FullRecipeModel>;
      });
    } else {
      debugPrint("Error while querying reicpes!");
    }
  }

  Widget buildFloatingSearchBar(BuildContext ctx) {
    final isPortrait = MediaQuery.of(ctx).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: barController,
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
      onQueryChanged: (query) => _getRecipesByName(ctx, query),
      onSubmitted: (query) => _getRecipesByName(ctx, query),
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: () {
              setState(() {
                queryiedRecipes = <FullRecipeModel>[];
              });
              ctx.read<NewMealPlanningState>().setIsSearchModalOpen(false);
            },
          ),
        ),
        FloatingSearchBarAction.icon(
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
          showIfClosed: false,
          showIfOpened: true,
          onTap: () {
            setState(() {
              queryiedRecipes = [];
              barController.clear();
            });
          },
        ),
      ],
      builder: (context, transition) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (queryiedRecipes.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: queryiedRecipes.length,
            itemBuilder: (BuildContext context, int index) {
              return RecipeCard(
                recipe: queryiedRecipes[index],
                margin: const EdgeInsets.symmetric(vertical: 5),
              );
            },
          );
        }
        //Else if()
        else {
          return SearchMealHistory(searchBarController: barController);
        }
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
