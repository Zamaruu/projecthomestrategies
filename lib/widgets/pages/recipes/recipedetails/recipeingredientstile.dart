import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_ingredients_model.dart';

class RecipeIgredientTile extends StatelessWidget {
  final Ingredients ingredient;

  const RecipeIgredientTile({Key? key, required this.ingredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "${ingredient.name}:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Text(ingredient.amount!),
            ),
          ],
        ),
      ),
    );
  }
}
