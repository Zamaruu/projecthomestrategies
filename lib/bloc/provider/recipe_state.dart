import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';

class RecipeState with ChangeNotifier {
  late List<FullRecipeModel> _publicRecipes;
  List<FullRecipeModel> get publicRecipes => _publicRecipes;

  RecipeState() {
    _publicRecipes = <FullRecipeModel>[];
  }

  void setInitialData(List<FullRecipeModel> publicRecipes) {
    _publicRecipes = publicRecipes;
  }
}
