import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_recipe_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/bottomdialogactionbar.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipeingredients.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipesteps.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/recipeimageupload.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/recipeinformation.dart';
import 'package:provider/provider.dart';

class NewRecipeDialog extends StatelessWidget {
  const NewRecipeDialog({Key? key}) : super(key: key);

  Future<void> createNewRecipe(BuildContext ctx) async {
    var loader = LoadingSnackbar(ctx);

    var recipe = ctx.read<NewRecipeState>().buildRecipe(ctx);
    var token = Global.getToken(ctx);

    loader.showLoadingSnackbar();
    ctx.read<NewRecipeState>().setIsLoading(true);
    var response = await RecipeService(token).createNewRecipe(recipe);
    ctx.read<NewRecipeState>().setIsLoading(false);
    loader.dismissSnackbar();

    if (response.isSuccess()) {
      Navigator.of(ctx).pop();
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
      appBar: AppBar(title: const Text("Neues Rezept erstellen")),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          const RecipeImageUpload(),
          NewRecipeInformation(),
          const NewRecipeIngredients(),
          const NewRecipeCookingsteps(),
        ],
      ),
      bottomNavigationBar: CreateRecipeBottomBar(
        onCreate: () => createNewRecipe(context),
      ),
    );
  }
}
