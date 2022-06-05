import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/basiccard.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/draweravatar.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipedetails/recipedetailsbuilder.dart';

class RecipeCard extends StatelessWidget {
  final FullRecipeModel recipe;
  final EdgeInsets margin;

  const RecipeCard({
    Key? key,
    required this.recipe,
    this.margin = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  }) : super(key: key);

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

  void _pushDetailsPage(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => RecipeDetailsBuilder(id: recipe.recipe!.id!),
      ),
    );
  }

  Align _favouriteBadge() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 5,
              blurRadius: 5,
            )
          ],
        ),
        child: Icon(
          recipe.isFavourite! ? Icons.favorite : Icons.favorite_outline,
          size: 30,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushDetailsPage(context),
      child: Card(
        elevation: 10,
        margin: margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "imageOf${recipe.recipe!.id}",
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(recipe.recipe!.getImageAsBytes()!),
                  ),
                ),
                child: recipe.isFavourite! ? _favouriteBadge() : null,
              ),
            ),
            ListTile(
              leading: buildAvatar(),
              title: Text(recipe.recipe!.name ?? "Fehler beim namen"),
              subtitle: Text(
                "von ${recipe.creator!.firstname!} ${recipe.creator!.surname!}",
              ),
              trailing: SizedBox(
                width: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${recipe.recipe!.cookingTime} min"),
                    const SizedBox(width: 5),
                    const Icon(Icons.timer),
                  ],
                ),
              ),
            ),
            if (recipe.recipe!.desctiption != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  recipe.recipe!.desctiption!,
                  textAlign: TextAlign.left,
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
                    onPressed: () => _pushDetailsPage(context),
                    icon: const Icon(Icons.info),
                    label: const Text("Mehr Informationen"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BasicRecipeCard extends StatelessWidget {
  final PlannedMealModel meal;

  const BasicRecipeCard({Key? key, required this.meal}) : super(key: key);

  UserAvatar buildAvatar() {
    var firstLetter = meal.creator!.firstname![0];
    var lastLetter = meal.creator!.surname![0];

    return UserAvatar(
      firstLetter: firstLetter,
      lastLetter: lastLetter,
      color: meal.creator!.color!,
      avatarRadius: 45,
      fontSize: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
              meal.basicRecipeName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          ListTile(
            leading: buildAvatar(),
            title: Text(
              "von ${meal.creator!.firstname!} ${meal.creator!.surname!}",
            ),
          ),
        ],
      ),
    );
  }
}
