import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/detailrecipe_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class RecipeActions extends StatefulWidget {
  const RecipeActions({Key? key}) : super(key: key);

  @override
  State<RecipeActions> createState() => _RecipeActionsState();
}

class _RecipeActionsState extends State<RecipeActions> {
  late bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void setFavouriteStatus(BuildContext ctx, bool currentStatus) async {
    var id = ctx.read<DetailRecipeState>().recipe.recipe!.id!;

    if (currentStatus) {
      setIsLoading(true);

      var token = Global.getToken(ctx);
      var response = await RecipeService(token).removeRecipeAsFavourite(id);

      setIsLoading(false);

      if (response.statusCode == 200) {
        ctx.read<DetailRecipeState>().removeFavouriteStatusOf(id);
        ctx.read<RecipeState>().removeRecipeFromFavourites(id);
      } else {
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
    } else {
      setIsLoading(true);

      var token = Global.getToken(ctx);
      var response = await RecipeService(token).setRecipeAsFavourite(id);

      setIsLoading(false);

      if (response.statusCode == 200) {
        ctx.read<DetailRecipeState>().setFavouriteStatusOf(id);
        ctx
            .read<RecipeState>()
            .addRecipeToFavourite(ctx.read<DetailRecipeState>().recipe);
      } else {
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Selector<DetailRecipeState, bool>(
            selector: (context, model) => model.recipe.isFavourite!,
            builder: (context, isFavourite, _) {
              return SizedBox(
                height: kBottomNavigationBarHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => setFavouriteStatus(context, isFavourite),
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          height: kBottomNavigationBarHeight / 0.6,
                          child: CircularProgressIndicator(),
                        )
                      : Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_outline,
                          color: Colors.red,
                        ),
                  label: const Text("Speichern"),
                ),
              );
            },
          ),
          SizedBox(
            height: kBottomNavigationBarHeight,
            width: MediaQuery.of(context).size.width / 2,
            child: TextButton.icon(
              onPressed: isLoading ? null : () {},
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
