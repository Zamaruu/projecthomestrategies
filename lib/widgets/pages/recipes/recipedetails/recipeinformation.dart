import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';

class RecipeInformation extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeInformation({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (recipe.desctiption != null)
            const SizedBox(
              height: 15,
            ),
          if (recipe.desctiption != null)
            const Text(
              "Beschreibung",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          Text(recipe.desctiption ?? ""),
        ],
      ),
    );
  }
}
