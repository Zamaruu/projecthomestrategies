import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/roundcheckbox.dart';

class ShoppingListItem extends StatefulWidget {
  final int listIndex;
  final String itemName;
  final Function onItemBought;

  const ShoppingListItem({ Key? key, required this.onItemBought, required this.listIndex, required this.itemName }) : super(key: key);

  @override
  _ShoppingListItemState createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  late bool dismissed;

  @override
  void initState() {
    super.initState();
    dismissed = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: dismissed? 0.0: 1.0,
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: RoundCheckbox(
            initialValue: false,
            onChanged: (newValue){
              if(newValue){
                setState(() {
                  dismissed = true;
                });
                Future.delayed(const Duration(milliseconds: 700), () => widget.onItemBought(widget.listIndex));
              }
            },
          ),
          title: Text(
            widget.itemName,
          ),
          trailing: IconButton(
            splashRadius: Global.splashRadius,
            icon: const Icon(Icons.delete),
            onPressed: (){},
          ),
        ),
      ),
    );
  }
}