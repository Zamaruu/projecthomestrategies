import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';

class FullRecipeModel {
  RecipeModel? recipe;
  UserModel? creator;
  bool? isFavourite;

  FullRecipeModel({this.recipe, this.creator, this.isFavourite});

  FullRecipeModel.fromJson(Map<String, dynamic> json) {
    recipe =
        json['recipe'] != null ? RecipeModel.fromJson(json['recipe']) : null;
    creator =
        json['creator'] != null ? UserModel.fromJson(json['creator']) : null;
    isFavourite = json['isFavourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipe != null) {
      data['recipe'] = recipe!.toJson();
    }
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['isFavourite'] = isFavourite!;
    return data;
  }
}
