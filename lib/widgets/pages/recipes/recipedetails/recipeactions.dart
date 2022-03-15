import 'package:flutter/material.dart';

class RecipeActions extends StatefulWidget {
  const RecipeActions({Key? key}) : super(key: key);

  @override
  State<RecipeActions> createState() => _RecipeActionsState();
}

class _RecipeActionsState extends State<RecipeActions> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            height: kBottomNavigationBarHeight,
            width: MediaQuery.of(context).size.width / 2,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
              ),
              label: const Text("Speichern"),
            ),
          ),
          SizedBox(
            height: kBottomNavigationBarHeight,
            width: MediaQuery.of(context).size.width / 2,
            child: TextButton.icon(
              onPressed: () {},
              // style: TextButton.styleFrom(
              //   primary: Colors.grey.shade700,
              // ),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text("Kochen"),
            ),
          ),
        ],
      ),
    );
  }
}
