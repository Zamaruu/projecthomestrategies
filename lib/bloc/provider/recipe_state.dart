import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';

class RecipeState with ChangeNotifier {
  late List<FullRecipeModel> _publicRecipes;
  List<FullRecipeModel> get publicRecipes => _publicRecipes;

  //Detailed Recipes
  final int _numberOfCachedDetailedRecipes = 10;
  late List<FullRecipeModel> _detailedRecipes;
  List<FullRecipeModel> get detailedRecipes => _detailedRecipes;

  //Favourite Recipes
  late List<FullRecipeModel> _favouriteRecipes;
  List<FullRecipeModel> get favouriteRecipes => _favouriteRecipes;

  RecipeState() {
    _publicRecipes = <FullRecipeModel>[];
    _detailedRecipes = <FullRecipeModel>[];
    _favouriteRecipes = <FullRecipeModel>[];
  }

  bool hasRecipeData() {
    return _publicRecipes.isNotEmpty;
  }

  void setInitialData(List<FullRecipeModel> publicRecipes) {
    _publicRecipes = publicRecipes;
  }

  void setRecipes(List<FullRecipeModel> publicRecipes) {
    _publicRecipes = publicRecipes;
  }

  // -----------------------------------------------------------
  // Detailed Recipes
  bool detailedRecipesContains(String id) {
    return _detailedRecipes.any((r) => r.recipe!.id! == id);
  }

  FullRecipeModel getRecipeWithIdFromCache(String id) {
    return _detailedRecipes.firstWhere((element) => element.recipe!.id! == id);
  }

  void addRecipeToCache(FullRecipeModel recipe) {
    if (detailedRecipesContains(recipe.recipe!.id!)) {
      return;
    }
    if (detailedRecipes.length == _numberOfCachedDetailedRecipes) {
      _detailedRecipes.removeLast();
    }

    _detailedRecipes = [...detailedRecipes, recipe];
  }

  void clearDetailedRecipeCache() {
    _detailedRecipes = <FullRecipeModel>[];
    notifyListeners();
  }

  // -----------------------------------------------------------
  // Favourite Recipes
  bool isFavouritesNotEmpty() {
    return _favouriteRecipes.isNotEmpty;
  }

  void setFavourites(List<FullRecipeModel> favourites, {bool notify = false}) {
    _favouriteRecipes = favourites;

    if (notify) {
      notifyListeners();
    }
  }

  void addRecipeToFavourite(FullRecipeModel recipe) {
    if (favouriteRecipes
        .any((element) => element.recipe!.id == recipe.recipe!.id)) {
      return;
    }

    _favouriteRecipes = [...favouriteRecipes, recipe];
    notifyListeners();
  }

  void removeRecipeFromFavourites(String id) {
    if (!favouriteRecipes.any((element) => element.recipe!.id == id)) {
      return;
    }

    int index =
        favouriteRecipes.indexWhere((element) => element.recipe!.id == id);

    _favouriteRecipes = List.from(favouriteRecipes)..removeAt(index);
    notifyListeners();
  }
}
