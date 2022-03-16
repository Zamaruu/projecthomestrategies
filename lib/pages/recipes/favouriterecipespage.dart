import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:provider/provider.dart';

class FavouriteRecipesPage extends StatelessWidget {
  const FavouriteRecipesPage({Key? key}) : super(key: key);

  Future<void> refreshFavourites(BuildContext ctx) async {
    var token = Global.getToken(ctx);
    ApiResponseModel response =
        await RecipeService(token).getFavouriteRecipes();

    if (response.isSuccess()) {
      var recipes = response.object as List<FullRecipeModel>;

      ctx.read<RecipeState>().setFavourites(recipes, notify: true);
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
      body: Selector<RecipeState, List<FullRecipeModel>>(
        selector: (context, model) => model.favouriteRecipes,
        builder: (context, favourites, _) {
          if (favourites.isEmpty) {
            return const Center(
              child: Text("Keine Favoriten"),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshFavourites(context),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: favourites.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeCard(recipe: favourites[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
