import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:provider/provider.dart';

class SearchMealsOverlay extends StatefulWidget {
  const SearchMealsOverlay({Key? key}) : super(key: key);

  @override
  State<SearchMealsOverlay> createState() => _SearchMealsOverlayState();
}

class _SearchMealsOverlayState extends State<SearchMealsOverlay> {
  late List<FullRecipeModel> queryiedRecipes;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    queryiedRecipes = <FullRecipeModel>[];
  }

  void _toggleIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<dynamic> _getRecipesByName(BuildContext ctx, String query) async {
    _toggleIsLoading(true);

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

  Widget _searchHistoy() {
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
  }

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
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
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
          return _searchHistoy();
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
