import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class FullRecipeModel {
  RecipeModel? recipe;
  UserModel? creator;

  FullRecipeModel({this.recipe, this.creator});

  FullRecipeModel.fromJson(Map<String, dynamic> json) {
    recipe =
        json['recipe'] != null ? RecipeModel.fromJson(json['recipe']) : null;
    creator =
        json['creator'] != null ? UserModel.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipe != null) {
      data['recipe'] = recipe!.toJson();
    }
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    return data;
  }
}
