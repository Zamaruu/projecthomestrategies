import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/bloc/provider/filter_bills_state.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/pages/billspage/billspage.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:provider/provider.dart';
import 'package:projecthomestrategies/service/billing_service.dart';

class BillContentBuilder extends StatelessWidget {
  const BillContentBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthenticationState>(
      builder: (context, auth, child) {
        return TokenProvider(
          tokenBuilder: (token) {
            return FutureBuilder<Map<String, List>>(
              future: BillingService(token).getBillsAndCategories(
                auth.getSessionHousehold(),
              ),
              builder: (
                BuildContext context,
                AsyncSnapshot<Map<String, List>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {}
                if (snapshot.hasError) {
                  return ErrorPageHandler(error: snapshot.error.toString());
                } else {
                  var bills = snapshot.data!["bills"]! as List<BillModel>;
                  var categories =
                      snapshot.data!["categories"]! as List<BillCategoryModel>;

                  context.read<BillFilterState>().initFilter(
                        users: snapshot.data!['users'] as List<UserModel>,
                        categories: categories,
                      );

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
      },
    );
  }
}
