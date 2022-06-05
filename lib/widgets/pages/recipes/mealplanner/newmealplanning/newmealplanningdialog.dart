import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/fullrecipe.dart';
import 'package:projecthomestrategies/bloc/provider/new_meal_planning_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/recipe_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/basiccard.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/divider/finishstepdivider.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/mealplanningbottombar.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/searchmealsoverlay.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/newmealplanning/selectmealcard.dart';
import 'package:projecthomestrategies/widgets/pages/settings/selectcolordialog.dart';
import 'package:provider/provider.dart';

class NewMealPlanningDialog extends StatelessWidget {
  const NewMealPlanningDialog({Key? key}) : super(key: key);

  Future<bool> _shouldPop(BuildContext ctx) async {
    var isSearchModalOpen = ctx.read<NewMealPlanningState>().isSearchModalOpen;
    if (isSearchModalOpen) {
      ctx.read<NewMealPlanningState>().setIsSearchModalOpen(false);
      return false;
    }
    return true;
  }

  Future<void> _submitMealPlanning(BuildContext ctx) async {
    var loader = LoadingSnackbar(ctx);

    var mealPlanning = ctx.read<NewMealPlanningState>().buildMealPlanning(ctx);
    var token = Global.getToken(ctx);

    loader.showLoadingSnackbar();
    ctx.read<NewMealPlanningState>().setIsLoading(true);
    var response =
        await RecipeService(token).createNewMealPlanning(mealPlanning);

    ctx.read<NewMealPlanningState>().setIsLoading(false);
    loader.dismissSnackbar();

    if (response.isSuccess()) {
      Navigator.of(ctx).pop(true);
    } else {
      ctx.read<NewMealPlanningState>().setIsLoading(false);

      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _shouldPop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("Neues Planning")),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _MealTypeBuilder(),
                const _MealDateRange(),
                const _ColorSelect(),
              ],
            ),
            const SearchMealsOverlay(),
          ],
        ),
        bottomNavigationBar: Selector<NewMealPlanningState, bool>(
          selector: (context, state) => state.isPlanningValid(),
          builder: (context, isValid, _) {
            if (isValid) {
              return MealPlanningBottomBar(
                onCreate: () => _submitMealPlanning(context),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class _MealTypeBuilder extends StatelessWidget {
  final FocusNode focus = FocusNode();

  _MealTypeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _RecipeSection(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: TextStepDivider(text: "oder"),
        ),
        _BasicRecipeNameSection(focusNode: focus),
      ],
    );
  }
}

class _RecipeSection extends StatelessWidget {
  const _RecipeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewMealPlanningState>(
      builder: (context, state, _) {
        if (state.selectedRecipe != null) {
          return SelectMealCard(
            onSelectIcon: Icons.clear,
            onSelectText: "Rezept löschen",
            recipe: state.selectedRecipe!,
            onSelect: () => context.read<NewMealPlanningState>().removeRecipe(),
            margin: const EdgeInsets.symmetric(vertical: 5),
          );
        } else {
          return OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(90),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              side: BorderSide(
                color: Global.isStringNullOrEmpty(
                        state.basicRecipeNameController!.text)
                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                    : Colors.grey,
              ),
            ),
            onPressed: Global.isStringNullOrEmpty(
                    state.basicRecipeNameController!.text)
                ? () => {
                      context
                          .read<NewMealPlanningState>()
                          .setIsSearchModalOpen(true),
                    }
                : null,
            icon: const Icon(Icons.ramen_dining),
            label: const Text("Rezept auswählen"),
          );
        }
      },
    );
  }
}

class _BasicRecipeNameSection extends StatelessWidget {
  final FocusNode focusNode;

  const _BasicRecipeNameSection({Key? key, required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewMealPlanningState>(
      builder: (context, state, _) {
        return TextInputField(
          enabled: state.selectedRecipe == null,
          controller: state.basicRecipeNameController!,
          helperText: "Gerichtname",
          type: TextInputType.text,
          focusNode: focusNode,
        );
      },
    );
  }
}

class _MealDateRange extends StatelessWidget {
  const _MealDateRange({Key? key}) : super(key: key);

  Future<void> getTime(BuildContext ctx, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: ctx,
      locale: const Locale("de", "DE"),
      initialDate: isStartDate
          ? ctx.read<NewMealPlanningState>().startDate
          : ctx.read<NewMealPlanningState>().endDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      if (isStartDate) {
        if (picked.isBefore(ctx.read<NewMealPlanningState>().endDate)) {
          ctx.read<NewMealPlanningState>().setStartDate(picked);
        }
      } else {
        if (picked.isAfter(ctx.read<NewMealPlanningState>().startDate)) {
          ctx.read<NewMealPlanningState>().setEndDate(picked);
        }
      }
    }
  }

  Row timeRow(BuildContext ctx, String text, DateTime date, bool isStartDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
        TextButton(
          onPressed: () => getTime(ctx, isStartDate),
          child: Text(
            Global.datetimeToDeString(
              date,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: 8,
      child: Consumer<NewMealPlanningState>(
        builder: (context, state, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Zeitraum",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            timeRow(
              context,
              "Vom ",
              state.startDate,
              true,
            ),
            timeRow(
              context,
              "bis ",
              state.endDate,
              false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSelect extends StatelessWidget {
  const _ColorSelect({Key? key}) : super(key: key);

  Future<void> selectColorDialog(BuildContext ctx, Color currentColor) async {
    var color = await showDialog<Color>(
      context: ctx,
      builder: (context) {
        return SelectColorDialog(currentColor: currentColor);
      },
    );
    if (color != null) {
      ctx.read<NewMealPlanningState>().setColor(color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewMealPlanningState>(
      builder: (context, state, _) => BasicCard(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state.color,
            ),
          ),
          title: const Text("Anzeigefarbe"),
          trailing: IconButton(
            tooltip: "Bearbeiten",
            onPressed: () async {
              await selectColorDialog(
                context,
                state.color,
              );
            },
            splashRadius: Global.splashRadius,
            icon: const Icon(Icons.color_lens),
          ),
        ),
      ),
    );
  }
}
