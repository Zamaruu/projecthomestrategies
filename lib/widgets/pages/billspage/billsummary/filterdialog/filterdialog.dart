import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/filter_bills_state.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/filterdialog/filtercategoiessection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/filterdialog/filteruserssection.dart';
import 'package:provider/provider.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text("Rechnungen filtern"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        children: const [
          FilterUsersSection(),
          FilterCategoriesSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<BillFilterState>().resetFilter(context);
        },
        tooltip: "Filter zurücksetzen",
        child: const Icon(
          Icons.search_off,
          color: Colors.black,
        ),
      ),
    );
  }
}
