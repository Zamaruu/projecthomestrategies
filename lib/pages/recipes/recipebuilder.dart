import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/pages/recipes/recipepage.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class RecipeBuilder extends StatelessWidget {
  const RecipeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.read<RecipeState>().hasRecipeData()) {
      return const RecipePage();
    } else {
      return Consumer<AuthenticationState>(
        builder: (context, auth, _) => FutureBuilder<ApiResponseModel>(
          future: RecipeService(auth.token).getRecipesBasic(),
          builder: (
            BuildContext context,
            AsyncSnapshot<ApiResponseModel> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
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
        ),
      );
    }
  }
}
