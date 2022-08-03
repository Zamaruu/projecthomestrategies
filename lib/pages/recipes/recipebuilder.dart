import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/pages/recipes/recipepage.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/homestrategies_fullscreen_loader.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class RecipeBuilder extends StatelessWidget {
  const RecipeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.read<RecipeState>().hasRecipeData()) {
      return const RecipePage();
    } else {
      return Consumer<FirebaseAuthenticationState>(builder: (context, auth, _) {
        return TokenProvider(
          tokenBuilder: (token) {
            return FutureBuilder<ApiResponseModel>(
              future: RecipeService(token).getRecipesBasic(),
              builder: (
                BuildContext context,
                AsyncSnapshot<ApiResponseModel> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const HomestrategiesFullscreenLoader(
                    loaderLabel: "Lade Rezepte",
                  );
                }
                if (snapshot.hasError) {
                  return ErrorPageHandler(error: snapshot.error.toString());
                } else {
                  var publicRecipes =
                      snapshot.data!.object as List<FullRecipeModel>;
                  context.read<RecipeState>().setInitialData(publicRecipes);

                  return const RecipePage();
                }
              },
            );
          },
        );
      });
    }
  }
}
