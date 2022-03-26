import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';
import 'package:projecthomestrategies/bloc/provider/new_recipe_state.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/divider/finishstepdivider.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/divider/nextstepdivider.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipestepdialog.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipecookingsteps.dart';
import 'package:provider/provider.dart';

class NewRecipeCookingsteps extends StatelessWidget {
  const NewRecipeCookingsteps({Key? key}) : super(key: key);

  Future<void> createNewStep(BuildContext ctx) async {
    var currentLength = ctx.read<NewRecipeState>().cookingSteps.length + 1;
    var response = await showDialog<CookingStepModel?>(
      context: ctx,
      builder: (context) => RecipeStepDialog(
        index: currentLength,
      ),
    );

    if (response != null) {
      ctx.read<NewRecipeState>().addCookingStep(response);
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
          const PanelHeading(heading: "Kochschritte"),
          Selector<NewRecipeState, List<CookingStepModel>>(
            selector: (context, model) => model.cookingSteps,
            builder: (context, steps, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const NextCookingStepDivider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return CoockingStepTile(step: steps[index]);
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
              onPressed: () => createNewStep(context),
              icon: const Icon(Icons.add),
              label: const Text("Kochschritt hinzufügen"),
            ),
          ),
        ],
      ),
    );
  }
}
