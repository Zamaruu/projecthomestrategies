import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';

class RecipeState with ChangeNotifier {
  late List<FullRecipeModel> _publicRecipes;
  List<FullRecipeModel> get publicRecipes => _publicRecipes;

  //Detailed Recipes
  final int _numberOfCachedDetailedRecipes = 10;
  late List<FullRecipeModel> _detailedRecipes;
  List<FullRecipeModel> get detailedRecipes => _detailedRecipes;

  RecipeState() {
    _publicRecipes = <FullRecipeModel>[];
    _detailedRecipes = <FullRecipeModel>[];
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
}
