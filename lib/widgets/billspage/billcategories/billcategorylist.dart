import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/billcategorytile.dart';
import 'package:provider/provider.dart';

class BillCategoryList extends StatefulWidget {
  const BillCategoryList({Key? key}) : super(key: key);

  @override
  _BillCategoryListState createState() => _BillCategoryListState();
}

class _BillCategoryListState extends State<BillCategoryList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BillingState>(
      builder: (context, state, _) {
        if (state.billCategories.isEmpty) {
          return const Center(
            child: Text("Keine Kategorien"),
          );
        } else {
          return ListView.builder(
            itemCount: state.billCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return BillCategoryTile(
                billCategory: state.billCategories[index],
              );
            },
          );
        }
      },
    );
  }
}
