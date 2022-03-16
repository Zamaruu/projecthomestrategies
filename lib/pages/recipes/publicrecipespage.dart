import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:provider/provider.dart';

class PublicRecipesPage extends StatelessWidget {
  const PublicRecipesPage({Key? key}) : super(key: key);

  Future<void> refreshRecipes(BuildContext ctx) async {
    var token = Global.getToken(ctx);
    ApiResponseModel response = await RecipeService(token).getRecipesBasic();

    if (response.isSuccess()) {
      var recipes = response.object as List<FullRecipeModel>;

      ctx.read<RecipeState>().clearDetailedRecipeCache();
      ctx.read<RecipeState>().setRecipes(recipes);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<RecipeState>(
        builder: (context, state, _) {
          return RefreshIndicator(
            onRefresh: () => refreshRecipes(context),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.publicRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                return RecipeCard(recipe: state.publicRecipes[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
