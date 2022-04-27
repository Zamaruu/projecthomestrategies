import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SearchMealHistory extends StatefulWidget {
  final FloatingSearchBarController searchBarController;

  const SearchMealHistory({Key? key, required this.searchBarController})
      : super(key: key);

  @override
  State<SearchMealHistory> createState() => _SearchMealHistoryState();
}

class _SearchMealHistoryState extends State<SearchMealHistory> {
  late List<String> searchHistory = [];

  Future<List<String>> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    var history = prefs.getStringList(Global.kMealSearchHistoryKey);

    if (Global.isListNullOrEmpty(history)) {
      return <String>[];
    } else {
      return searchHistory = history!;
    }
  }

  void onHistoryObjectTap(String query) {
    widget.searchBarController.query = query;
  }

  void clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      searchHistory = [];
      prefs.remove(Global.kMealSearchHistoryKey);
    });
  }

  Container searchHistoryObject(String queryString) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () => onHistoryObjectTap(queryString),
          title: Text(queryString),
        ),
      ),
    );
  }

  Container _noContentContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }

  Widget _deleteHistory(int length) {
    if (length >= 1) {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: ElevatedButton.icon(
          onPressed: () => clearSearchHistory(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(35), // NEW
          ),
          icon: const Icon(Icons.delete),
          label: const Text("Suchhistorie löschen"),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: loadSearchHistory(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(45)),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return _noContentContainer("Fehler beim laden der Suchhistorie");
        } else {
          var publicRecipes = snapshot.data!;

          if (publicRecipes.isEmpty) {
            return _noContentContainer("Noch keine Suchhistorie vorhanden");
          }
          return Column(
            children: [
              _deleteHistory(searchHistory.length),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchHistory.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 7.5);
                },
                itemBuilder: (BuildContext context, int index) {
                  return searchHistoryObject(searchHistory[index]);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
