import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/filterdialog/filtercategoiessection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/filterdialog/filteruserssection.dart';

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
        children: const [
          FilterUsersSection(),
          FilterCategoiesSection(),
        ],
      ),
    );
  }
}
