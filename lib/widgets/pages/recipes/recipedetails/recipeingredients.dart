import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_ingredients_model.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeingredientstile.dart';

class RecipeIngredients extends StatelessWidget {
  final List<Ingredients> ingredients;

  const RecipeIngredients({Key? key, required this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Zutaten",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              return RecipeIgredientTile(ingredient: ingredients[index]);
            },
          ),
        ],
      ),
    );
  }
}
