import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/selectmealcard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'searchmealhistory.dart';

class SearchMealBar extends StatefulWidget {
  const SearchMealBar({Key? key}) : super(key: key);

  @override
  State<SearchMealBar> createState() => _SearchMealBarState();
}

class _SearchMealBarState extends State<SearchMealBar> {
  late List<FullRecipeModel> queryiedRecipes;
  late bool isLoading;
  late FloatingSearchBarController barController;
  late bool isPortrait = true;

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
    var token = await Global.getToken(ctx);
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

  List<Widget> searchbarActions() {
    return <FloatingSearchBarAction>[
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () {
            setState(() {
              queryiedRecipes = <FullRecipeModel>[];
            });
            context.read<NewMealPlanningState>().setIsSearchModalOpen(false);
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

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
      onQueryChanged: (query) => _getRecipesByName(context, query),
      onSubmitted: (query) => _getRecipesByName(context, query),
      transition: CircularFloatingSearchBarTransition(),
      actions: searchbarActions(),
      builder: (context, transition) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (queryiedRecipes.isNotEmpty) {
          return _QueryResults(queryResults: queryiedRecipes);
        }
        //Else if()
        else {
          return SearchMealHistory(searchBarController: barController);
        }
      },
    );
  }
}

class _QueryResults extends StatelessWidget {
  final List<FullRecipeModel> queryResults;

  const _QueryResults({Key? key, required this.queryResults}) : super(key: key);

  void onCardSelect(BuildContext ctx, FullRecipeModel recipe) {
    ctx.read<NewMealPlanningState>().setRecipe(recipe);
    ctx.read<NewMealPlanningState>().setIsSearchModalOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: queryResults.length,
      itemBuilder: (BuildContext context, int index) {
        return SelectMealCard(
          onSelectIcon: Icons.done,
          onSelectText: "Rezept auswählen",
          recipe: queryResults[index],
          onSelect: () => onCardSelect(context, queryResults[index]),
          margin: const EdgeInsets.symmetric(vertical: 5),
        );
      },
    );
  }
}
