import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:provider/provider.dart';

class PublicRecipesPage extends StatelessWidget {
  const PublicRecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<RecipeState>(
        builder: (context, state, _) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.publicRecipes.length,
            itemBuilder: (BuildContext context, int index) {
              return RecipeCard(recipe: state.publicRecipes[index]);
            },
          );
        },
      ),
    );
  }
}
