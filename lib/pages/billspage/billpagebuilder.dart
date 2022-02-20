import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/pages/billspage/billspage.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';
import 'package:projecthomestrategies/service/billing_service.dart';

class BillContentBuilder extends StatelessWidget {
  const BillContentBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (context, auth, child) {
        return FutureBuilder<Map<String, List>>(
          future: BillingService(auth.token).getBillsAndCategories(
            auth.getSessionHousehold(),
          ),
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, List>> snapshot,
          ) {
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
              var bills = snapshot.data!["bills"]! as List<BillModel>;
              var categories =
                  snapshot.data!["categories"]! as List<BillCategoryModel>;

              // cache.setBills(bills, notify: false);
              // cache.setBillCategories(categories, notify: false);

              context.read<BillingState>().setInitialData(
                    categories,
                    bills,
                  );
              return const BillsPage();
            }
          },
        );
      },
    );
  }
}
