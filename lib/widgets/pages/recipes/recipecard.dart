import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/draweravatar.dart';

class RecipeCard extends StatelessWidget {
  final FullRecipeModel recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  UserAvatar buildAvatar() {
    var firstLetter = recipe.creator!.firstname![0];
    var lastLetter = recipe.creator!.surname![0];

    return UserAvatar(
      firstLetter: firstLetter,
      lastLetter: lastLetter,
      color: recipe.creator!.color!,
      avatarRadius: 45,
      fontSize: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://www.aponet.de/fileadmin/_processed_/f/e/csm_26141_cheeseburger_9e68312998.jpg"),
              ),
            ),
          ),
          ListTile(
            leading: buildAvatar(),
            title: Text(recipe.recipe!.name ?? "Fehler beim namen"),
            subtitle: Text(
              "von ${recipe.creator!.firstname!} ${recipe.creator!.surname!}",
            ),
          ),
          if (recipe.recipe!.desctiption != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                recipe.recipe!.desctiption!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text("Kochen"),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info),
                  label: const Text("Mehr Informationen"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
