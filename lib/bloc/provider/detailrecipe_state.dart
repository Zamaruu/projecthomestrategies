import 'package:flutter/cupertino.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';

class DetailRecipeState with ChangeNotifier {
  late FullRecipeModel _recipe;
  FullRecipeModel get recipe => _recipe;

  DetailRecipeState(FullRecipeModel model) {
    _recipe = model;
  }

  void setFavouriteStatusOf(String id) {
    recipe.isFavourite = true;
    notifyListeners();
  }

  void removeFavouriteStatusOf(String id) {
    recipe.isFavourite = false;
    notifyListeners();
  }
}
