import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/pages/recipes/favouriterecipespage.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class FavouritePageBuilder extends StatelessWidget {
  const FavouritePageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.read<RecipeState>().isFavouritesNotEmpty()) {
      return const FavouriteRecipesPage();
    } else {
      return Consumer<AuthenticationState>(
        builder: (context, auth, _) => FutureBuilder<ApiResponseModel>(
          future: RecipeService(auth.token).getFavouriteRecipes(),
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
              var favouriteRecipes =
                  snapshot.data!.object as List<FullRecipeModel>;
              context.read<RecipeState>().setFavourites(favouriteRecipes);

              return const FavouriteRecipesPage();
            }
          },
        ),
      );
    }
  }
}
