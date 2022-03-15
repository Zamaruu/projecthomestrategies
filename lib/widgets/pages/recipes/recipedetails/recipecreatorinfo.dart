import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/recipe_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/draweravatar.dart';

class RecipeCreatorInfo extends StatelessWidget {
  final RecipeModel recipe;
  final UserModel creator;

  const RecipeCreatorInfo({
    Key? key,
    required this.recipe,
    required this.creator,
  }) : super(key: key);

  UserAvatar buildAvatar() {
    var firstLetter = creator.firstname![0];
    var lastLetter = creator.surname![0];

    return UserAvatar(
      firstLetter: firstLetter,
      lastLetter: lastLetter,
      color: creator.color!,
      avatarRadius: 45,
      fontSize: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildAvatar(),
      title: Text("von ${creator.firstname!} ${creator.surname!}"),
      subtitle: Text(
        "am ${Global.datetimeToDeString(recipe.createdAt!)}",
      ),
      trailing: SizedBox(
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${recipe.cookingTime} min"),
            const SizedBox(width: 5),
            const Icon(Icons.timer),
          ],
        ),
      ),
    );
  }
}
