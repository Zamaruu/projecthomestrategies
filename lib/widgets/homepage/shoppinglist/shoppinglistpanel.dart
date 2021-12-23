import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/homepage/basiclistcontainer.dart';
import 'package:projecthomestrategies/widgets/homepage/panelheading.dart';
import 'package:projecthomestrategies/widgets/homepage/shoppinglist/shoppinglistadditemmodal.dart';
import 'package:projecthomestrategies/widgets/homepage/shoppinglist/shoppinglistitem.dart';

class ShoppinglistPanel extends StatefulWidget {
  const ShoppinglistPanel({ Key? key }) : super(key: key);

  @override
  _ShoppinglistPanelState createState() => _ShoppinglistPanelState();
}

class _ShoppinglistPanelState extends State<ShoppinglistPanel> {
  late List<String> shoppingItems;

  @override
  void initState() {
    super.initState();
    shoppingItems = List.generate(4, (index) => "Essen $index");
  }

  void removeTaskFromList(int index){
    setState(() {
      shoppingItems.removeAt(index);
    });
  }

  void addItemToList() async {
    //String can be null due to abort of adding process
    String? newItem = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return AddShoppingItemModal();
      },
    );
    
    if(newItem != null){
      if(newItem.isNotEmpty){
        setState(() {
          shoppingItems.add(newItem);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomepageListContainer(
      topMargin: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PanelHeading(heading: "Einkaufsliste für den 24.12."),
              const Spacer(),
              IconButton(
                splashRadius: Global.splashRadius,
                onPressed: addItemToList, 
                icon: Icon(Icons.add_circle_sharp, color: Colors.grey.shade700,)
              ),
              const SizedBox(width: 20,)
            ],
          ),
          shoppingItems.isNotEmpty?
            AnimationLimiter(
              child: ListView.builder(
                itemCount: shoppingItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: ShoppingListItem(
                          key: Key(shoppingItems[index]), //Damit die Checkboxen richtig gerendert werden wenn eine Task beendet wird! 
                          listIndex: index,
                          onItemBought: removeTaskFromList,
                          itemName: shoppingItems[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ):
            const SizedBox(
              height: 75,
              child: Center(
                child: Text(
                  "Keine Dinge mehr auf der Einkaufsliste.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}