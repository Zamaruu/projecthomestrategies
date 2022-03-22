import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/recipeimageupload.dart';

class NewRecipeDialog extends StatelessWidget {
  const NewRecipeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neues Rezept erstellen")),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: const [RecipeImageUpload()],
      ),
    );
  }
}
