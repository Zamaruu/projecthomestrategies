import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_recipe_state.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipedialog.dart';
import 'package:provider/provider.dart';

class NewRecipeBuilder extends StatelessWidget {
  const NewRecipeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewRecipeState(),
      builder: (context, _) => const NewRecipeDialog(),
    );
  }
}
