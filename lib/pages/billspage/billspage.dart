import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/pages/billspage/billcategories.dart';
import 'package:projecthomestrategies/pages/billspage/billinganalysis.dart';
import 'package:projecthomestrategies/pages/billspage/billsummary.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';

class MountBillProvider extends StatelessWidget {
  const MountBillProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BillingState(<BillCategoryModel>[], <BillModel>[]),
      child: const BillContentBuilder(),
    );
  }
}

class BillContentBuilder extends StatelessWidget {
  const BillContentBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingState>(
      builder: (context, state, _) {
        if (!state.isEmpty()) {
          return const BillsPage();
        } else {
          return Consumer<AuthenticationState>(
            builder: (context, auth, child) {
              return FutureBuilder<Map<String, List>>(
                future: BillingService(auth.token).getBillsAndCategories(
                  auth.sessionUser.household!.householdId!,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorPageHandler(error: snapshot.error.toString());
                  } else {
                    var bills = snapshot.data!["bills"]!;
                    var categories = snapshot.data!["categories"]!;

                    state.setInitialData(
                      categories as List<BillCategoryModel>,
                      bills as List<BillModel>,
                    );
                    return const BillsPage();
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}

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
