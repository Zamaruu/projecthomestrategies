import 'package:flutter/material.dart';
import 'package:projecthomestrategies/pages/recipes/favouriterecipespage.dart';
import 'package:projecthomestrategies/pages/recipes/mealplannerpage.dart';
import 'package:projecthomestrategies/pages/recipes/publicrecipespage.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/favouiterecipes/favoritepagebuilder.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/newrecipe/newrecipebuilder.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  final List<Widget> _pages = <Widget>[
    const PublicRecipesPage(),
    const Scaffold(
      backgroundColor: Colors.transparent,
    ),
    const FavouritePageBuilder(),
    const MealPlannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Rezepte",
      body: TabBarView(
        controller: _tabController,
        children: _pages,
      ),
      fab: FloatingActionButton(
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.3, color: Colors.grey[300]!),
          ),
        ),
        height: kBottomNavigationBarHeight,
        child: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          labelColor: Theme.of(context).primaryColor,
          controller: _tabController,
          tabs: const <Tab>[
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Gerichte",
              icon: Icon(Icons.ramen_dining),
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Meine",
              icon: Icon(Icons.person),
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Gespeichert",
              icon: Icon(Icons.favorite),
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Planner",
              icon: Icon(Icons.date_range),
            ),
          ],
        ),
      ),
    );
  }
}
