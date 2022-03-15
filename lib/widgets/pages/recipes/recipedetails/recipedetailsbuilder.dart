import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/detailrecipe_state.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipedetailspage.dart';
import 'package:provider/provider.dart';

class RecipeDetailsBuilder extends StatelessWidget {
  final String id;

  const RecipeDetailsBuilder({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (context, auth, _) => FutureBuilder<ApiResponseModel>(
        future: RecipeService(auth.token).getSingleRecipe(id),
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
            var fullRecipe = snapshot.data!.object as FullRecipeModel;

            return ChangeNotifierProvider(
              create: (context) => DetailRecipeState(fullRecipe),
              child: const RecipeDetailsPage(),
            );
          }
        },
      ),
    );
  }
}
