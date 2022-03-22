// ignore_for_file: prefer_initializing_formals, must_be_immutable

import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/cookingstep_model.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';

class RecipeStepDialog extends StatelessWidget {
  late CookingStepModel? step;
  late int? index;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final FocusNode nameNode = FocusNode();
  final FocusNode descNode = FocusNode();

  RecipeStepDialog({Key? key, CookingStepModel? step, int? index})
      : super(key: key) {
    this.step = step;
    this.index = index ?? step!.stepNumber!;

    if (step == null) {
      nameController = TextEditingController(text: "");
      descriptionController = TextEditingController(text: "");
    } else {
      nameController = TextEditingController(text: step.title);
      descriptionController = TextEditingController(text: step.description);
    }
  }

  CookingStepModel buildCookingStep() {
    return CookingStepModel(
      stepNumber: index ?? step!.stepNumber,
      title: nameController.text.trim(),
      description: nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Neuer Kochschritt"),
      content: SizedBox(
        height: 260,
        child: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              PanelHeading(heading: "Schritt $index"),
              TextInputField(
                verticalMargin: 15,
                controller: nameController,
                helperText: "Name",
                type: TextInputType.text,
                focusNode: nameNode,
                maxChars: 60,
              ),
              TextInputField(
                controller: descriptionController,
                helperText: "Schritt Beschreibung",
                type: TextInputType.text,
                focusNode: descNode,
                maxChars: 120,
                maxLines: 5,
              ),
            ],
          ),
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
          text: step != null ? "Ändern" : "Hinzufügen",
          icon: step != null ? Icons.done : Icons.add,
        ),
      ],
    );
  }
}
