import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/bloc/provider/detailrecipe_state.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/detailimage.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeactions.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipecookingsteps.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipecreatorinfo.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeinformation.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeingredients.dart';
import 'package:provider/provider.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<DetailRecipeState, RecipeModel>(
      selector: (context, model) => model.recipe.recipe!,
      builder: (context, recipe, _) => Selector<DetailRecipeState, UserModel>(
        selector: (context, model) => model.recipe.creator!,
        builder: (context, creator, _) => Scaffold(
          appBar: AppBar(
            title: Text(recipe.name ?? ""),
          ),
          body: ListView(
            children: [
              RecipeImage(
                heroTag: "imageOf${recipe.id}",
                image: recipe.getImageAsBytes()!,
              ),
              RecipeCreatorInfo(
                recipe: recipe,
                creator: creator,
              ),
              const RecipeActions(),
              RecipeInformation(
                recipe: recipe,
              ),
              if (recipe.ingredients != null)
                RecipeIngredients(
                  ingredients: recipe.ingredients!,
                ),
              if (recipe.cookingSteps != null)
                RecipeCookingSteps(
                  cookingSteps: recipe.cookingSteps!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
