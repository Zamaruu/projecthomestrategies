import 'package:flutter/material.dart';
import 'package:projecthomestrategies/pages/billspage/billcategories.dart';
import 'package:projecthomestrategies/pages/billspage/billinganalysis.dart';
import 'package:projecthomestrategies/pages/billspage/billsummary.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';

// ignore: must_be_immutable
class BillsPage extends StatefulWidget {
  const BillsPage({Key? key}) : super(key: key);

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  late int pageIndex;

  @override
  void initState() {
    pageIndex = 0;
    super.initState();
  }

  final List<String> pageTitles = <String>[
    "Rechnungen",
    "Kategorien",
    "Analyse",
  ];

  final List<Widget> _pages = <Widget>[
    const BillsSummary(),
    const BillCategoriesDialog(),
    const BillingsAnalysis(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: pageTitles.elementAt(pageIndex),
      body: _pages.elementAt(pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) {
          if (index != pageIndex) {
            setState(() {
              pageIndex = index;
            });
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.euro),
            label: "Rechnungen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: "Kategorien",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analyse",
          ),
        ],
      ),
    );
  }
}
