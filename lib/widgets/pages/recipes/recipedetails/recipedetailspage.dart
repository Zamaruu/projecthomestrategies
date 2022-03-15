import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/detailimage.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeactions.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipecookingsteps.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipecreatorinfo.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeinformation.dart';

class RecipeDetailsPage extends StatelessWidget {
  final RecipeModel recipe;
  final UserModel creator;

  const RecipeDetailsPage({
    Key? key,
    required this.recipe,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name ?? ""),
      ),
      body: ListView(
        children: [
          RecipeImage(
            image: recipe.getImageAsBytes()!,
          ),
          RecipeCreatorInfo(recipe: recipe, creator: creator),
          const RecipeActions(),
          RecipeInformation(
            recipe: recipe,
          ),
          if (recipe.cookingSteps != null)
            RecipeCookingSteps(cookingSteps: recipe.cookingSteps!),
        ],
      ),
    );
  }
}
