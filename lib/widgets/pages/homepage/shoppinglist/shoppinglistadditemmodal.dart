import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';

class AddShoppingItemModal extends StatelessWidget {
  final TextEditingController newItemController = TextEditingController();

  AddShoppingItemModal({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gegenstand hinzufügen"),
      content: TextFormField(
        decoration: const InputDecoration(
          hintText: "Neuer Gegenstand"
        ),
        controller: newItemController,
        maxLength: 30,
      ),
      actions: [
        CancelButton(
          onCancel: () => Navigator.of(context).pop(),
        ),
        PrimaryButton(
          text: "Hinzufügen",
          icon: Icons.add,
          onPressed: (){
            if(newItemController.text.isNotEmpty){
              Navigator.of(context).pop(newItemController.text.trim());
            }
          },
        ),
      ],
    );
  }
}