import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipebuilder.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:provider/provider.dart';

class PublicRecipesPage extends StatefulWidget {
  const PublicRecipesPage({Key? key}) : super(key: key);

  @override
  State<PublicRecipesPage> createState() => _PublicRecipesPageState();
}

class _PublicRecipesPageState extends State<PublicRecipesPage> {
  late bool isLoading;
  late bool finalPageReached;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    finalPageReached = false;
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> refreshRecipes(BuildContext ctx) async {
    var token = Global.getToken(ctx);
    ApiResponseModel response = await RecipeService(token).getRecipesBasic();

    if (response.isSuccess()) {
      setState(() {
        finalPageReached = false;
      });
      var recipes = response.object as List<FullRecipeModel>;

      ctx.read<RecipeState>().resetPagingData();
      ctx.read<RecipeState>().clearDetailedRecipeCache();
      ctx.read<RecipeState>().setRecipes(recipes);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "PublicRecipesFabTag",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const NewRecipeBuilder(),
            ),
          );
        },
        tooltip: "Neues Rezept erstellen",
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.transparent,
      body: Consumer<RecipeState>(
        builder: (context, state, _) {
          return RefreshIndicator(
            onRefresh: () => refreshRecipes(context),
            child: ListView(
              physics: state.publicRecipes.length >= 2
                  ? const BouncingScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.publicRecipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecipeCard(recipe: state.publicRecipes[index]);
                  },
                ),
                const PaginationArea(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaginationArea extends StatelessWidget {
  const PaginationArea({Key? key}) : super(key: key);

  Future<void> _loadMore(BuildContext ctx) async {
    var recipeState = ctx.read<RecipeState>();
    if (recipeState.finalPageReached) {
      ApiResponseHandlerService.custom(
        context: ctx,
        customMessage: "Es sind keine weiteren Rechnungen vorhanden!",
        statusCode: 500,
      ).showSnackbar();

      return;
    }

    recipeState.setIsLoading(true);

    var page = recipeState.pageCount;
    var token = Global.getToken(ctx);

    page = page + 1;

    var response = await RecipeService(token).getRecipesBasic(
      pageNumber: page,
      pageSize: recipeState.pageSize,
    );

    recipeState.setIsLoading(false);

    if (response.statusCode == 200) {
      var newRecipes = response.object as List<FullRecipeModel>;

      if (newRecipes.isNotEmpty) {
        recipeState.setPageCount(page);
        recipeState.addReciepes(newRecipes);
      }

      if (newRecipes.length < recipeState.pageSize) {
        recipeState.setFinalPageReached(true);
      }
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeState>(
      builder: (context, state, _) {
        if (!state.isLoading && !state.finalPageReached) {
          return TextButton(
            onPressed: () => _loadMore(context),
            child: const Text("Mehr laden..."),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
