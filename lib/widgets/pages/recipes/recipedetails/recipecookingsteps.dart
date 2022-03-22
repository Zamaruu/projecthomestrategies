import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/divider/finishstepdivider.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/divider/nextstepdivider.dart';

class RecipeCookingSteps extends StatelessWidget {
  final List<CookingStepModel> cookingSteps;

  const RecipeCookingSteps({Key? key, required this.cookingSteps})
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
            "Kochschritte",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cookingSteps.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CoockingStepTile(step: cookingSteps[index]),
                  if (index < cookingSteps.length - 1)
                    const NextCookingStepDivider(),
                  if (index == cookingSteps.length - 1)
                    const FinishStepDivider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CoockingStepTile extends StatelessWidget {
  final CookingStepModel step;

  const CoockingStepTile({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Schritt ${step.stepNumber}: ${step.title}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(step.description!),
          ],
        ),
      ),
    );
  }
}
