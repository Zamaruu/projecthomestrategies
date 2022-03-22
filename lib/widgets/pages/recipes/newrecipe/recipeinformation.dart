import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_recipe_state.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';

class NewRecipeInformation extends StatelessWidget {
  final FocusNode nameNode = FocusNode();
  final FocusNode descNode = FocusNode();

  NewRecipeInformation({Key? key}) : super(key: key);

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
        children: <Widget>[
          const PanelHeading(heading: "Rezeptinformationen"),
          TextInputField(
            verticalMargin: 15,
            controller: context.read<NewRecipeState>().recipeName,
            helperText: "Rezeptname",
            type: TextInputType.text,
            focusNode: nameNode,
            maxChars: 60,
          ),
          TextInputField(
            controller: context.read<NewRecipeState>().description,
            helperText: "Beschreibung",
            type: TextInputType.text,
            focusNode: descNode,
            maxChars: 240,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
