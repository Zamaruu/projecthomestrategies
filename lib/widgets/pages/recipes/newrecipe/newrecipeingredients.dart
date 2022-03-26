import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_ingredients_model.dart';
import 'package:projecthomestrategies/bloc/provider/new_recipe_state.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipeingredientsdialog.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipeingredientstile.dart';
import 'package:provider/provider.dart';

class NewRecipeIngredients extends StatelessWidget {
  const NewRecipeIngredients({Key? key}) : super(key: key);

  Future<void> addNewIngredient(BuildContext ctx) async {
    var currentLength = ctx.read<NewRecipeState>().cookingSteps.length + 1;
    var response = await showDialog<Ingredients?>(
      context: ctx,
      builder: (context) => RecipeIngredientsDialog(
        index: currentLength,
      ),
    );

    if (response != null) {
      ctx.read<NewRecipeState>().addIngredient(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          const PanelHeading(heading: "Zutaten"),
          Selector<NewRecipeState, List<Ingredients>>(
            selector: (context, model) => model.ingredients,
            builder: (context, ingredients, _) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: ingredients.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return RecipeIgredientTile(ingredient: ingredients[index]);
                },
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            height: 80,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(90),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                side: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
              onPressed: () => addNewIngredient(context),
              icon: const Icon(Icons.add),
              label: const Text("Zutat hinzufügen"),
            ),
          ),
        ],
      ),
    );
  }
}
