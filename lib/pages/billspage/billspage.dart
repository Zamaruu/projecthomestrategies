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

class _BillsPageState extends State<BillsPage>
    with SingleTickerProviderStateMixin {
  late int pageIndex;
  late TabController _tabController;

  @override
  void initState() {
    pageIndex = 0;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        pageIndex = _tabController.index;
      });
    });
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
      //body: _pages.elementAt(pageIndex),
      body: BodyTabView(children: _pages, controller: _tabController),
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
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          tabs: const <Tab>[
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Rechnungen",
              icon: Icon(Icons.euro),
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Kategorien",
              icon: Icon(Icons.list_alt_rounded),
            ),
            Tab(
              iconMargin: EdgeInsets.only(bottom: 5),
              text: "Analyse",
              icon: Icon(Icons.analytics),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyTabView extends StatelessWidget {
  final List<Widget> children;
  final TabController controller;
  const BodyTabView(
      {Key? key, required this.children, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: children,
    );
  }
}
