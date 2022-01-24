import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/billcategorytile.dart';

class BillCategoryList extends StatefulWidget {
  final List<BillCategoryModel> billCategories;

  const BillCategoryList({Key? key, required this.billCategories})
      : super(key: key);

  @override
  _BillCategoryListState createState() => _BillCategoryListState();
}

class _BillCategoryListState extends State<BillCategoryList> {
  @override
  Widget build(BuildContext context) {
    if (widget.billCategories.isEmpty) {
      return const Center(
        child: Text("Keine Kategorien"),
      );
    } else {
      return ListView.builder(
        itemCount: widget.billCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return BillCategoryTile(
            billCategory: widget.billCategories[index],
          );
        },
      );
    }
  }
}
