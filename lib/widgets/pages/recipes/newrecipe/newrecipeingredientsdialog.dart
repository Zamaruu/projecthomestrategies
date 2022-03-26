// ignore_for_file: prefer_initializing_formals, must_be_immutable

import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';
import 'package:projecthomestrategies/bloc/models/recipe_ingredients_model.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';

class RecipeIngredientsDialog extends StatelessWidget {
  late Ingredients? ingredient;
  late int? index;
  late TextEditingController nameController;
  late TextEditingController amountController;
  final FocusNode nameNode = FocusNode();
  final FocusNode amountNode = FocusNode();

  RecipeIngredientsDialog({Key? key, Ingredients? ingredient, int? index})
      : super(key: key) {
    this.ingredient = ingredient;

    if (ingredient == null) {
      nameController = TextEditingController(text: "");
      amountController = TextEditingController(text: "");
    } else {
      nameController = TextEditingController(text: ingredient.name);
      amountController = TextEditingController(text: ingredient.amount);
    }
  }

  Ingredients buildCookingStep() {
    return Ingredients(
      name: nameController.text.trim(),
      amount: amountController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Neue Zutat"),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            TextInputField(
              verticalMargin: 15,
              controller: nameController,
              helperText: "Name",
              type: TextInputType.text,
              focusNode: nameNode,
              maxChars: 40,
            ),
            TextInputField(
              controller: amountController,
              helperText: "Menge",
              type: TextInputType.text,
              focusNode: amountNode,
              maxChars: 40,
            ),
          ],
        ),
      ),
      actions: [
        CancelButton(
          onCancel: () => Navigator.of(context).pop(),
        ),
        PrimaryButton(
          onPressed: () => Navigator.of(context).pop(
            buildCookingStep(),
          ),
          text: ingredient != null ? "Ändern" : "Hinzufügen",
          icon: ingredient != null ? Icons.done : Icons.add,
        ),
      ],
    );
  }
}
